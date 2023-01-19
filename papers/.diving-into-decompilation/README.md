# Diving Into Smart Contract Decompilation

  ##### January 17, 2023&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![Heimdall Header](https://raw.githubusercontent.com/Jon-Becker/heimdall-rs/main/preview.png?fw)

  The Heimdall-rs decompilation module is a powerful tool for understanding the inner workings of Ethereum smart contracts. It allows users to convert raw bytecode into human-readable Solidity code and its corresponding Application Binary Interface (ABI). In this article, we will delve deep into the inner workings of the decompilation module, examining how it performs this conversion at a low level and exploring its various features and capabilities.

  Please keep in mind that this article talks about how heimdall-rs performs decompilation. This may not be the same as how other decompilers work. If you have any suggestions or corrections, please feel free to open an issue or pull request on [GitHub](https://github.com/Jon-Becker/heimdall-rs.! Thank you!

# 0x01. Introduction

  Decompilation is the process of converting machine code or bytecode into a higher-level, human-readable representation. However, it is not a straightforward task for several reasons:

  - Machine code or bytecode is designed to be executed by a computer, not read by humans. As a result, it can be ambiguous and difficult to interpret.
  - Bytecode does not contain information about variable and function names, making it difficult to understand the purpose of different parts of the code.
  - Bytecode does not contain all the information that the original source code had, like comments, variable and function names, types, etc.
  - Bytecode is not a linear representation of the source code, for multiple reasons such as compiler optimizations, making it even more challenging to decompile effectively.

  In order to make this complex, convoluted process easier to understand, I've broken the overall decompilation process into four main steps, which we will explore in detail in the following sections:

  - **Disassembly**: The process of converting bytecode into it's assembly representation.
  - **Symbolic Execution**: The process of generating a branch-like control flow graph (CFG) from the disassembled code.
  - **Branch Analysis**: The process of analyzing and translating the CFG into a higher-level representation.
  - **Post-Processing**: The process of cleaning up the output and making it more readable.

# 0x02. Disassembly

  The first step in the decompilation process is to convert the bytecode into a more human-readable assembly representation. This is done to allow the decompiler to find and analyze the different parts of the smart-contract, such as functions.

  Assembly is a low-level representation of the bytecode, where each instruction is represented by a mnemonic and its corresponding arguments. Each instruction has roughly 3 parts:

  ```
  <program_counter> <opcode> <arguments>
  ```

  The program counter is the index of the instruction in the bytecode. The opcode is the instruction itself, and the arguments are the values that the instruction operates on. For advanced information on Ethereum opcodes, check out [EVM Codes](https://www.evm.codes/?fork=arrowGlacier).

  For example, the following bytecode from *[0x1bf797219482a29013d804ad96d1c6f84fba4c45](https://etherscan.io/address/0x1bf797219482a29013d804ad96d1c6f84fba4c45)*:

  ```text
  731bf797219482a29013d804ad96d1c6f84fba4c45301460806040...9d5ef505ae7230ffc3d88c49ceeb7441e0029
  ```

  Would be converted into the following assembly:

  ```text
  20 PUSH20 1bf797219482a29013d804ad96d1c6f84fba4c45
  21 ADDRESS 
  22 EQ 
  24 PUSH1 80
  26 PUSH1 40
  27 MSTORE 
  29 PUSH1 04
  30 CALLDATASIZE 
  31 LT 
  34 PUSH2 0058
  35 JUMPI 
  37 PUSH1 00
  38 CALLDATALOAD 
  ...
  ```

## The Solidity Dispatcher

  Heimdall-rs uses this disassembled code to search for `JUMPI` statements in the dispatch lookup table, which is used to determine the function that is being called. In the Ethereum Virtual Machine (EVM), functions are called by passing a function selector as the first 4 bytes of the calldata. The function selector is a hash of the function signature, which is the function name and its corresponding arguments. For example, the function signature `transfer(address,uint256)` would be converted into the function selector `0xa9059cbb`.

  The dispatch lookup table is a mapping of function selectors to the corresponding function address (as a program counter). It is used to determine which function is being called by the first 4 bytes of the calldata. Typically, `CALLDATALOAD(0)` is used to load the first 4 bytes of the calldata, and then the function selector is compared to the function selectors in the dispatch lookup table to determine which function is being called. If a match is found, the program jumps to the corresponding location in the bytecode.

  For example, the following assembly shows this dispatch table in action for the WETH contract *[0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2](https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2)*:

  ```text
  14 PUSH1 00
  15 CALLDATALOAD 
  45 PUSH29 0100000000000000000000000000000000000000000000000000000000
  46 SWAP1 
  47 DIV 
  52 PUSH4 ffffffff
  53 AND 
  54 DUP1 
  59 PUSH4 06fdde03
  60 EQ 
  63 PUSH2 00b9
  64 JUMPI 
  65 DUP1 
  70 PUSH4 095ea7b3
  71 EQ 
  74 PUSH2 0147
  75 JUMPI 
  ```

  From this, we can see that the function selector for `0x06fdde03` *(`name()`)* tells the EVM to jump to program counter `0xb9`, and the function selector for `0x095ea7b3` *(`approve(address,uint256)`)* tells the EVM to jump to program counter `0x147`. Heimdall-rs' decompile module searches through this dispatch lookup table to find all function selectors and their corresponding locations in bytecode, allowing for the symbolic execution and branch analysis steps to be performed.

# 0x03. Symbolic Execution

  The second step in the decompilation process is to generate a control flow graph (CFG) from the disassembled code. A CFG is a directed graph that represents the control flow of a program. Each node in the graph represents a block of instructions that are executed sequentially. Each edge in the graph represents a jump or branch, which is a conditional jump to another basic block. The CFG is used to represent the control flow of the program, and is used to determine the different paths that the program can take.

  This CFG is generated by heimdall-rs by executing the bytecode in a custom EVM implementation specifically designed for decompilation and bytecode analysis. Whenever the EVM encounters a `JUMPI` instruction, a new branch is created in the CFG. A new VM is created for each branch, and the program is executed until terminated. This process is repeated until all branches have been explored, and the CFG is complete.

  <details>
  <summary>
    This process can be seen in the following code snippit from <a href="https://github.com/Jon-Becker/heimdall-rs/blob/main/heimdall/src/decompile/util.rs#L279-L420">heimdall-rs</a>:
  </summary>

  ```rust
  pub fn recursive_map(
      evm: &VM,
      handled_jumpdests: &mut Vec<String>,
      path: &mut String,
  ) -> VMTrace {
      let mut vm = evm.clone();

      // create a new VMTrace object
      let mut vm_trace = VMTrace {
          instruction: vm.instruction,
          operations: Vec::new(),
          children: Vec::new(),
          loop_detected: false,
          depth: 0,
      };

      // cap the number of branches to prevent infinite loops. Needs to be fixed in the future.
      if handled_jumpdests.len() >= 1000 { return vm_trace }

      // step through the bytecode until we find a JUMPI instruction
      while vm.bytecode.len() >= (vm.instruction * 2 + 2) as usize {
          let state = vm.step();
          vm_trace.operations.push(state.clone());

          // if we encounter a JUMPI, create children taking both paths and break
          if state.last_instruction.opcode == "57" {
              vm_trace.depth += 1;

              path.push_str(&format!("{}->{};", state.last_instruction.instruction, state.last_instruction.inputs[0]));

              // we need to create a trace for the path that wasn't taken.
              if state.last_instruction.inputs[1] == U256::from(0) {

                  // break out of loops
                  match LOOP_DETECTION_REGEX.is_match(&path) {
                      Ok(result) => {
                          if result {
                              vm_trace.loop_detected = true;
                              break;
                          }
                      }
                      Err(_) => {
                          return vm_trace
                      }
                  }

                  handled_jumpdests.push(format!("{}@{}", vm_trace.depth, state.last_instruction.instruction));

                  // push a new vm trace to the children
                  let mut trace_vm = vm.clone();
                  trace_vm.instruction = state.last_instruction.inputs[0].as_u128() + 1;
                  vm_trace.children.push(recursive_map(
                      &trace_vm,
                      handled_jumpdests,
                      &mut path.clone()
                  ));

                  // push the current path onto the stack
                  vm_trace.children.push(recursive_map(
                      &vm.clone(),
                      handled_jumpdests,
                      &mut path.clone()
                  ));
                  break;
              } else {

                  // break out of loops
                  match LOOP_DETECTION_REGEX.is_match(&path) {
                      Ok(result) => {
                          if result {
                              vm_trace.loop_detected = true;
                              break;
                          }
                      }
                      Err(_) => {
                          return vm_trace
                      }
                  }

                  handled_jumpdests.push(format!("{}@{}", vm_trace.depth, state.last_instruction.instruction));

                  // push a new vm trace to the children
                  let mut trace_vm = vm.clone();
                  trace_vm.instruction = state.last_instruction.instruction + 1;
                  vm_trace.children.push(recursive_map(
                      &trace_vm,
                      handled_jumpdests,
                      &mut path.clone()
                  ));

                  // push the current path onto the stack
                  vm_trace.children.push(recursive_map(
                      &vm.clone(),
                      handled_jumpdests,
                      &mut path.clone()
                  ));
                  break;
              }
          }

          if vm.exitcode != 255 || vm.returndata.len() > 0 {
              break;
          }
      }

      vm_trace
  }
  ```

  Aside from the loop detection, this code is fairly straightforward. The VM is stepped through until a `JUMPI` instruction is encountered. The VM is then cloned, and the instruction pointer is set to the jump destination. The cloned VM is then passed to the `recursive_map` function, which will recursively step through the bytecode until it reaches a `JUMPI` instruction. This process is repeated until all branches have been explored, and the CFG is complete. 

  Loop detection is still something that needs to be improved upon. The current method of detecting loops is to check if the path taken so far matches a regular expression that matches the pattern of a loop. This method is not perfect, and can be fooled by certain bytecode patterns.
</details>
  
# 0x04. Branch Analysis

  Once the CFG is generated, the next step is to analyze the branches of the CFG. This is where the real decompilation begins, and translation from opcode to solidity begins.

  ### The WrappedOpcode Struct

  As stated earlier, decompilation and symbolic execution are powered by my custom EVM implementation. This implementation introduces `WrappedOpcodes` which are essentially opcodes with additional information. This information includes the instruction pointer, the inputs, and the outputs of the opcode. This information is used to generate the CFG, and is also used to generate the decompiled code.

  This struct can be seen in the following code snippit from <a href="https://github.com/Jon-Becker/heimdall-rs/blob/main/common/src/ether/evm/opcodes.rs#L163-L193">heimdall-rs</a>:
  
  ```rust
  // enum allows for Wrapped Opcodes to contain both raw U256 and Opcodes as inputs
  #[derive(Clone, Debug, PartialEq)]
  pub enum WrappedInput {
      Raw(U256),
      Opcode(WrappedOpcode),
  }

  // represents an opcode with its direct inputs as WrappedInputs
  #[derive(Clone, Debug, PartialEq)]
  pub struct WrappedOpcode {
      pub opcode: Opcode,
      pub inputs: Vec<WrappedInput>,
  }
  ```

  
  The VM implementation keeps track of these `WrappedOpcodes` as it steps through the bytecode. Allowing for each input and output for any instruction to be traced back to its origin. This is essential for decompilation, as it allows for the decompiler to know exactly what each instruction is doing and where its inputs are coming from, eventually allowing for the decompiler to generate the correct solidity code.

  <details>
  <summary>Raw WrappedOpcode</summary>

  ```rust
  [
      WrappedOpcode {
          opcode: Opcode {
              name: "SUB",
              mingas: 3,
              inputs: 2,
              outputs: 1,
          },
          inputs: [
              Opcode(
                  WrappedOpcode {
                      opcode: Opcode {
                          name: "ADD",
                          mingas: 3,
                          inputs: 2,
                          outputs: 1,
                      },
                      inputs: [
                          Opcode(
                              WrappedOpcode {
                                  opcode: Opcode {
                                      name: "PUSH1",
                                      mingas: 3,
                                      inputs: 0,
                                      outputs: 1,
                                  },
                                  inputs: [
                                      Raw(
                                          32,
                                      ),
                                  ],
                              },
                          ),
                          Opcode(
                              WrappedOpcode {
                                  opcode: Opcode {
                                      name: "MLOAD",
                                      mingas: 3,
                                      inputs: 1,
                                      outputs: 1,
                                  },
                                  inputs: [
                                      Opcode(
                                          WrappedOpcode {
                                              opcode: Opcode {
                                                  name: "PUSH1",
                                                  mingas: 3,
                                                  inputs: 0,
                                                  outputs: 1,
                                              },
                                              inputs: [
                                                  Raw(
                                                      64,
                                                  ),
                                              ],
                                          },
                                      ),
                                  ],
                              },
                          ),
                      ],
                  },
              ),
              Opcode(
                  WrappedOpcode {
                      opcode: Opcode {
                          name: "SLOAD",
                          mingas: 3,
                          inputs: 1,
                          outputs: 1,
                      },
                      inputs: [
                          Opcode(
                              WrappedOpcode {
                                  opcode: Opcode {
                                      name: "PUSH1",
                                      mingas: 3,
                                      inputs: 0,
                                      outputs: 1,
                                  },
                                  inputs: [
                                      Raw(
                                          1,
                                      ),
                                  ],
                              },
                          ),
                      ],
                  },
              ),
          ],
      },
  ]
  ```
  
  </details>

  ### Solidifying a WrappedOpcode

  The `WrappedOpcode` above essentially breaks down to

  ```rust
  SUB(
      ADD(
          PUSH1(32),
          MLOAD(
              PUSH1(64)
          )
      ),
      SLOAD(
          PUSH1(1)
      )
  )
  ```

  Which can be simplified further to

  ```rust
  SUB(ADD(32, MLOAD(64)), SLOAD(1))
  ```

  And could be represented in solidity* as

  ```rust
  (32 + memory[64]) - storage[1]
  ```

  This process of solidifying (converting to solidity) a `WrappedOpcode` is done recursively, and is done for every `WrappedOpcode` in the CFG. This allows for the decompiler to generate the solidity code for any given contract.

  In heimdall-rs, this process is done in the `solidify` function of the `WrappedOpcode` struct. This function can be seen in the following code snippit from <a href="https://github.com/Jon-Becker/heimdall-rs/blob/8157fae82bcf3b16a74e8fcb7ed0e53a62f56001/common/src/ether/solidity.rs#L24">heimdall-rs</a>:

  ```rust
  pub fn solidify(&self) -> String {
      let mut solidified_wrapped_opcode = String::new();

      match self.opcode.name.as_str() {
          "ADD" => {
              solidified_wrapped_opcode.push_str(
                  format!(
                      "{} + {}",
                      self.inputs[0]._solidify(),
                      self.inputs[1]._solidify()
                  ).as_str()
              );
          },
          "MUL" => {
              solidified_wrapped_opcode.push_str(
                  format!(
                      "{} * {}",
                      self.inputs[0]._solidify(),
                      self.inputs[1]._solidify()
                  ).as_str()
              );
          },
          "SUB" => {
              solidified_wrapped_opcode.push_str(
                  format!(
                      "{} - {}",
                      self.inputs[0]._solidify(),
                      self.inputs[1]._solidify()
                  ).as_str()
              );
          },
          ...
      }
  }
  ```

  ## Analyzing a CFG branch

  The CFG branch analysis is done by the `analyze` function of the `VMTrace` struct. This function can be viewed in the following code snippit from <a href="https://github.com/Jon-Becker/heimdall-rs/blob/main/heimdall/src/decompile/analyze.rs#L1">analyze.rs</a>. This function iterates over the operations in each branch of the `VMTrace` generated by symbolic execution and performs the bulk of the decompilation through the following steps:

  ### Determining Function Visibility

  The decompiler first determines whether or not the current opcode will modify the visibility of the function. In solidity, functions that are `pure` cannot read or write from the state via the following opcodes: 

  ```solidity
  BALANCE, ORIGIN, CALLER, GASPRICE, EXTCODESIZE, EXTCODECOPY, BLOCKHASH, COINBASE, TIMESTAMP, NUMBER, DIFFICULTY, GASLIMIT, CHAINID, SELFBALANCE, BASEFEE, SLOAD, SSTORE, CREATE, SELFDESTRUCT, CALL, CALLCODE, DELEGATECALL, STATICCALL, CREATE2
  ```

  If the current opcode is within this set of state-modifying opcodes, the `Function` struct has its property `pure` set to `false`.

  Similarly, functions that are `view` cannot write to the state via the following opcodes:

  ```solidity
  SSTORE, CREATE, SELFDESTRUCT, CALL, CALLCODE, DELEGATECALL, STATICCALL, CREATE2
  ```

  Again, if the current opcode is within this set of state-modifying opcodes, the `Function` struct has its property `view` set to `false`. This will also set the `pure` property to `false`.

  ### Translating Opcodes

  The main decompilation process is the translation of opcodes to their corresponding solidity code. The translation only happens for opcodes that directly modify memory or storage, as stack operations will be handled by `WrappedOpcode` solidifying.

  #### LOGN

  The `LOG0`, `LOG1`, `LOG2`, `LOG3`, and `LOG4` opcodes are translated to the corresponding `emit` statement in solidity.

  1. First, the event is saved to the `Function` struct for ABI generation.
  2. The `data` field of the log is decoded into variables via `WrappedOpcode::solidify`.
   
     ```rust
      let data_mem_ops: Vec<StorageFrame> = function.get_memory_range(instruction.inputs[0], instruction.inputs[1]);
      let data_mem_ops_solidified: String = data_mem_ops.iter().map(|x| x.operations.solidify()).collect::<Vec<String>>().join(", ");
     ```

     This yields us a string of the form `memory[0], (1 + memory[1]), ...`.
  3. Each `topic` is then solidified via `WrappedOpcode::solidify`.

     ```rust
     let mut solidified_topics: Vec<String> = Vec::new();
     for (i, _) in topics.iter().enumerate() {
         solidified_topics.push(instruction.input_operations[i+3].solidify());
     }
     ```
  4. The proper `emit` statement is generated with the following format:

      ```solidity
      emit Event_<selector>(<solidified_topics>, <data_mem_ops_solidified>);
      ```

      The typings and event naming are resolved at a later stage.

  #### JUMPI

  The `JUMPI` opcode is translated to the corresponding `if` statement in solidity. It's also used to handle pseudo `require()` statements, which will be fixed in a later version.

  1. First, we check if the `JUMPI` was not taken in this branch. If it was *not* taken and the branch `REVERT`s, we can assume that the `JUMPI` was a `require()` statement. 
  2. Otherwise, solidify the condition of the `JUMPI` and generate the `if` statement.
  3. We also check the conditional to determine if the function is `payable`. If the conditional is `!msg.value`, then the function may be `payable`.

  #### REVERT

  The `REVERT` opcode is translated to the corresponding `revert` statement in solidity. This straightforward opcode has a few special cases that are handled by the decompiler:

  1. If the `REVERT` data starts with `08c379a0` (the `Error(string)` signature), then the `revert` statement is generated with the corresponding error message. We can decode the error message and generate the `revert` statement with the following format:

      ```solidity
      if (!<condition>) revert("Error message");
      ```
  2. If the `REVERT` data starts with `4e487b71` (the `Panic(uint256)` signature), the statement is ignored. Since symbolic execution is guaranteed to find all branches, the panics will be included and can be ignored.
  3. If the above two cases are not met, this is a custom error. The decompiler saves these to the function logic as the following:
  
      ```solidity
      if (!<condition>) revert CustomError_<selector>();
      ```

      Again, these are saved for ABI generation, and will be resolved at a later stage.

  #### RETURN

  The `RETURN` opcode is translated to the corresponding `return` statement in solidity. We use this opcopde to determine the return type of the function with the following heuristics:

  1. If the return data is checked with an `ISZERO` we can assume that the return type is `bool`.
  2. If there are bitwise operations on the return data, we can perform our variable size checks to determine potential typings.
  3. For return data over 32 bytes, we can assume that the return type is `bytes` or `string`. The return type is also `memory`.
  4. If all else fails, we assume that the return type is `uint256`.

  #### SELFDESTRUCT

  This is very straightforward, and is translated to the corresponding `selfdestruct` statement in solidity:
  
  ```solidity
  selfdestruct(<address>);
  ```

  #### SSTORE and MSTORE

  The `SSTORE` opcode is translated to the corresponding `storage` statement in solidity. These are translated as:

  ```solidity
  storage[<key>] = <value>;
  ```

  Since `MSTORE` essentially does the same thing, we can translate it to the corresponding `memory` statement in solidity:

  ```solidity
  memory[<offset>] = <value>;
  ```

  #### CALL, CALLCODE, DELEGATECALL, and STATICCALL

  These opcodes are translated to the corresponding `call` statement in solidity. These are translated as:

  ```solidity
  (bool success, bytes memory ret0) = address(<address>).<opcode>{gas: <gas>, value: <value>}(<solidified_memory>);
  ```

  #### CREATE and CREATE2

  For simplicity, these opcodes are translated as assembly:

  - `CREATE`:

  ```solidity
  assembly { addr := create(<value>, <offset>, <size>) }
  ```
  - `CREATE2`:

  ```solidity
  assembly { addr := create(<value>, <offset>, <size>, <salt>) }
  ```

  #### CALLDATALOAD

  This opcode is used to determine arguments for the function. The following formula is used to determine the argument slot:

  ```rust
  let calldata_slot = (instruction.inputs[0].as_usize() - 4) / 32;
  ```
  
  So, for example, if the `CALLDATALOAD` is at offset `4`, then the argument slot is `0`. If the `CALLDATALOAD` is at offset `36`, then the argument slot is `1`.

  We then add this argument to the `Function` struct, along with some default potential types for the argument (e.g. `uint256`, `bytes32`, `int256`, `string`, `bytes`, `uint`, `int`). These potential types will be narrowed down later.

  #### ISZERO

  If the `ISZERO` is used on a `CALLDATALOAD` operation, we can assume that the argument could be within the set {`bool`, `bytes1`, `uint8`, `int8`}. We add these potential types to the argument.

  #### AND and OR

  These operations are checked if they modify the size of an argument via `CALLDATALOAD`, and will update the potential types of the argument accordingly.

  ### Determining Variable Types

  In most programming languages, variables and arguments have a type associated with them. When a program or smart contract is compiled, these types are often removed and replaced with bitwise masking operations. For example, an `address` in solidity is a 20-byte value. When compiled, the bytecode will often use bitwise masking operations to ensure that the value is exactly 20 bytes. This is done to save space in the bytecode, and to make the bytecode more efficient.

  We can use this heuristic to infer the types of variables and arguments in a smart contract, for example:

  ```rust
  AND(PUSH20(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), CALLDATALOAD(4))
  ```

  is understood by the decompiler to an argument in the first slot of calldata (since the first 4 bytes of calldata are used for the function selector). We know that this argument is likely a variable with type existing in {`address`, `uint160`, `bytes20`}. 

  We can use this heuristic to infer the *size* of any variable or argument in the smart contract. In order to settle on a type within the set of possibilities, we need to watch for how the smart-contract interacts with the value.

  For example, the decompiler assumes that the following is an `address`, since it's used as an address further in the program.

  ```rust
  STATICCALL(GAS(), AND(PUSH20(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), CALLDATALOAD(4)), ...)
  ```

  Additionally, the decompiler assumes that the following is a `uint256`, since it's used in arithmetic operations further in the program.

  ```rust
  ADD(PUSH1(0xFF), AND(PUSH20(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), CALLDATALOAD(4)))
  ```

  The same can be said for `bytes` types. For example, the decompiler assumes that the following is a `bytes32`, since it's used in bitwise operations further in the program.

  ```rust
  BYTE(0, AND(PUSH20(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), CALLDATALOAD(4)))
  ```

  Using these heuristics together, we can accurately infer the types of most variables and arguments in any given smart contract. If no heuristics can be applied to a variable, the decompiler looks for any other variables within the expression that can have their type inherited. For example:

  ```solidity
  function() external payable {
      uint256 a = 0;
      b = a + 1;
  }
  ```

  Since `a` is a typed variable and is used in the instantiation of `b`, it's typically safe for `b` to inherit the type of `a`:

  ```solidity
  function() external payable {
      uint256 a = 0;
      uint256 b = a + 1;
  }
  ```

  Where no type can be inferred, the decompiler defaults to either `bytes32` or `uint256`, as these are the most common 32-byte types in solidity.

  ### Handling Precompiled Contracts

  The EVM has a number of precompiled contracts that can perform certain operations, such as recovering the signer of a message. Heimdall-rs has support for these precompiled contracts, and can convert the external calls to their corresponding solidity functions.

  Handling these is very simple. Whenever the decompiler comes across an external call, it's checked if the `to` address is a precompiled contract. If it is, the decompiler can decode the calldata and convert the call to a solidity function call.

  For example, this simple [ECRecovery](https://etherscan.io/address/0x1bf797219482a29013d804ad96d1c6f84fba4c45) contract compiles almost perfectly to the following solidity code:

  <details>
  <summary>Click to expand</summary>

  ```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity >=0.8.0;

  /// @title            Decompiled Contract
  /// @author           Jonathan Becker <jonathan@jbecker.dev>
  /// @custom:version   heimdall-rs v0.2.2
  ///
  /// @notice           This contract was decompiled using the heimdall-rs decompiler.
  ///                     It was generated directly by tracing the EVM opcodes from this contract.
  ///                     As a result, it may not compile or even be valid solidity code.
  ///                     Despite this, it should be obvious what each function does. Overall
  ///                     logic should have been preserved throughout decompiling.
  ///
  /// @custom:github    You can find the open-source decompiler here:
  ///                       https://github.com/Jon-Becker/heimdall-rs

  contract DecompiledContract {
      
      /// @custom:selector    0x19045a25
      /// @custom:name        Unresolved_19045a25
      /// @param              arg0 ["bytes", "bytes32", "int", "int256", "string", "uint", "uint256"]
      /// @param              arg1 ["bytes", "uint256", "int256", "string", "bytes32", "uint", "int"]
      function Unresolved_19045a25(bytes memory arg0, bytes memory arg1) public payable returns (address) {
          bytes memory var_a = var_a + (0x20 + ((0x1f + (arg1) / 0x20) * 0x20));
          if (var_a.length == 0x41) {
              if (!(var_a[0x60]) < 0x1b) {
                  if (var_a[0x60] == 0x1b) {
                      if (var_a[0x60] == 0x1b) {
                          var_a = 0x20 + var_a;
                          uint256 var_d = arg0;
                          bytes1 var_e = var_a[0x60];
                          uint256 var_f = var_a[0x20];
                          uint256 var_g = var_a[0x40];
                          address var_h = ecrecover(var_d, var_e, var_f, var_g);
                          if (!var_h) { revert(); } else {
                              address var_d = var_h;
                              return(var_d);
                          }
                          return(0);
                      }
                      if (var_a[0x60] == 0x1c) {
                          var_a = 0x20 + var_a;
                          uint256 var_d = arg0;
                          bytes1 var_e = var_a[0x60];
                          uint256 var_f = var_a[0x20];
                          uint256 var_g = var_a[0x40];
                          address var_h = ecrecover(var_d, var_e, var_f, var_g);
                          if (!var_h) { revert(); } else {
                              address var_d = var_h;
                              return(var_d);
                          }
                          return(0);
                      }
                  }
                  if (var_a[0x60] + 0x1b == 0x1b) {
                      if (var_a[0x60] + 0x1b == 0x1c) {
                          var_a = 0x20 + var_a;
                          uint256 var_d = arg0;
                          bytes1 var_e = var_a[0x60] + 0x1b;
                          uint256 var_f = var_a[0x20];
                          uint256 var_g = var_a[0x40];
                          address var_h = ecrecover(var_d, var_e, var_f, var_g);
                          if (!var_h) { revert(); } else {
                              address var_d = var_h;
                              return(var_d);
                          }
                          return(0);
                      }
                      if (var_a[0x60] + 0x1b == 0x1b) {
                          return(0);
                          var_a = 0x20 + var_a;
                          uint256 var_d = arg0;
                          bytes1 var_e = var_a[0x60] + 0x1b;
                          uint256 var_f = var_a[0x20];
                          uint256 var_g = var_a[0x40];
                          address var_h = ecrecover(var_d, var_e, var_f, var_g);
                          if (!var_h) { revert(); } else {
                              address var_d = var_h;
                              return(var_d);
                          }
                      }
                  }
              }
              return(0);
          }
      }
  }
  ```
  </details>

  A full list of precompiled contracts can be found <a href="https://www.evm.codes/precompiled">here</a>.

  ### Recursively Analyze Child Branches

  The final step of branch analysis is to analyze the child branches of each `VMTrace`. Once all branches are analyzed, the logic of the contract should be fully extracted and is ready for post-processing.

  ## Post-Processing

  The final step of decompiling is post-processing. This step is responsible for cleaning up the decompiled code and making it more readable. It's also responsible for assigning readable names to variables, as well as resolving function, event, and error selectors.

  ### Resolving Selectors

  The first step of post-processing is to resolve selectors for functions, errors, and events. This is done by using Samczsun's [Ethereum Signature Database](https://sig.eth.samczsun.com/) API to resolve the selectors, and find their matching signatures. Once we have a list of potential signatures for each selector, we check if they match the arguments of the function, event, or error. If they do, we replace the selector with the signature.

  For example, the following selector:

  ```solidity
  function Unresolved_19045a25(bytes memory arg0, bytes memory arg1) public payable returns (address) {
  ```

  would be replaced with:

  ```solidity
  function recover(bytes32 arg0, bytes memory arg1) public payable returns (address) {
  ```

  after resolving the selector.

  ### Building the ABI

  Now that we have a list of resolved and unresolved selectors, we can build the ABI for the contract. This is very straightforward, as we just need to build a JSON file with the following structs:

  ```rust
  #[derive(Serialize, Deserialize)]
  struct FunctionABI {
      #[serde(rename = "type")]
      type_: String,
      name: String,
      inputs: Vec<ABIToken>,
      outputs: Vec<ABIToken>,
      #[serde(rename = "stateMutability")]
      state_mutability: String,
      constant: bool,
  }

  #[derive(Serialize, Deserialize)]
  struct ErrorABI {
      #[serde(rename = "type")]
      type_: String,
      name: String,
      inputs: Vec<ABIToken>
  }


  #[derive(Serialize, Deserialize)]
  struct EventABI {
      #[serde(rename = "type")]
      type_: String,
      name: String,
      inputs: Vec<ABIToken>
  }
  ```

  After building these structs from the list of resolved and unresolved selectors, we can serialize them to JSON and write them to a file, giving us a beautiful and extremely accurate ABI for the contract.

  ### Cleaning Up the Code

  We can now assemble the solidity code from the contract logic. Before being finalized, each line is passed through a series of post-processing steps to clean up the code and make it more readable.

  1. Convert all bitwise masks to casts.

      For example:

      ```solidity
      (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) & (arg0);
      ```

      would be converted to:

      ```solidity
      uint256(arg0);
      ```
  2. Simplify Casts

      For example:

      ```solidity
      ecrecover(uint256(uint256(arg0)), uint256(uint256(arg0)), uint256(uint256(uint256(arg0))));
      ```

      would be simplified as:

      ```solidity
      ecrecover(uint256(arg0), uint256(arg0), uint256(arg0));
      ```
  3. Convert `iszero(...)` to `!(...)`
  4. Simplify parentheses

      For example:

      ```solidity
      if (((((((((((((((cast(((((((((((arg0 * (((((arg1))))))))))))) + 1)) / 10)))))))))))))))) {
      ```

      would be simplified as:

      ```solidity
      if (cast((arg0 * (arg1)) + 1 / 10)) {
      ```
  5. Convert all memory accesses to variables. For example:

      ```solidity
      memory[0x20] = 0;
      memory[0x40] = memory[0x20] + 0x20;
      ```

      would be converted to:

      ```solidity
      var_a = 0;
      var_b = var_a + 0x20;
      ```
  6. Remove expressions where existing variables can be used
  7. Move all outermost type castings to variable declarations. For example:

      ```solidity
      var_a = uint256(arg0);
      ```

      would be converted to:

      ```solidity
      uint256 var_a = arg0;
      ```
  8. Inherit or infer types from existing variables within expressions.
  9. Replace all resolved selectors with their signatures.
  10. Remove unused variable assignments.
  
  ## Conclusion

  That's it! We've now successfully decompiled a contract. The final step is to write the decompiled code to a file, and we're done! Hopefully this article has shed some light on how decompilers work, and how they can be used to analyze smart contracts. If you have any questions, feel free to reach out to me on [Twitter](https://twitter.com/BeckerrJon).