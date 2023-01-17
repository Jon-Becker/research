# Diving into 

  ##### January 17, 2023&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![Heimdall Header](https://raw.githubusercontent.com/Jon-Becker/heimdall-rs/main/preview.png?fw)

  The Heimdall-rs decompilation module is a powerful tool for understanding the inner workings of Ethereum smart contracts. It allows users to convert raw bytecode into human-readable Solidity code and its corresponding Application Binary Interface (ABI). In this article, we will delve deep into the inner workings of the decompilation module, examining how it performs this conversion at a low level and exploring its various features and capabilities.

# 0x01. Introduction

  Decompilation is the process of converting machine code or bytecode into a higher-level, human-readable representation. However, it is not a straightforward task for several reasons:

  - Machine code or bytecode is designed to be executed by a computer, not read by humans. As a result, it can be ambiguous and difficult to interpret.
  - Bytecode does not contain information about variable and function names, making it difficult to understand the purpose of different parts of the code.
  - Bytecode does not contain all the information that the original source code had, like comments, variable and function names, types, etc.
  - Bytecode is not a linear representation of the source code, for multiple reasons such as compiler optimizations, making it even more challenging to decompile effectively.

  In order to make this complex, convoluted process easier to understand, I've broken the overall decompilation process into four main steps, which we will explore in detail in the following sections:

  - **Disassembly**: The process of converting bytecode into it's assembly representation.
  - **Static Analysis**: The process of generating a branch-like control flow graph (CFG) from the disassembled code.
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

  From this, we can see that the function selector for `0x06fdde03` *(`name()`)* tells the EVM to jump to program counter `0xb9`, and the function selector for `0x095ea7b3` *(`approve(address,uint256)`)* tells the EVM to jump to program counter `0x147`. Heimdall-rs' decompile module searches through this dispatch lookup table to find all function selectors and their corresponding locations in bytecode, allowing for the static analysis and branch analysis steps to be performed.

# 0x03. Static Analysis

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

  As stated earlier, decompilation and static analysis are powered by my custom EVM implementation. This implementation introduces `WrappedOpcodes` which are essentially opcodes with additional information. This information includes the instruction pointer, the inputs, and the outputs of the opcode. This information is used to generate the CFG, and is also used to generate the decompiled code.

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

  The CFG branch analysis is done by the `analyze` function of the `VMTrace` struct. This function can be viewed in the following code snippit from <a href="https://github.com/Jon-Becker/heimdall-rs/blob/main/heimdall/src/decompile/analyze.rs#L1">analyze.rs</a>. This function iterates over the operations in each branch of the `VMTrace` generated by static analysis and performs the bulk of the decompilation through the following steps:

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

  ### Determining Argument Types

  