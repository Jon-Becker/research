# Heimdall-rs 0.8.0

![preview](https://raw.githubusercontent.com/Jon-Becker/heimdall-rs/main/preview.png?fw)

The heimdall-rs 0.8.0 release is our largest update to date with 34 merged PRs, hundreds of closed issues, countless hours of work, and six new contributors! Due to the sheer size of this release, we've decided to make a blog post to highlight the most significant changes.

For those interested, you can find the full changelog [here](https://github.com/Jon-Becker/heimdall-rs/releases/tag/0.8.0).

## Codebase Improvements

The most significant change in this release is the complete overhaul of the codebase. Almost every file has been touched, and all modules (decode, decompile, cfg, dump, disassemble and inspect) have been either entirely rewritten or significantly improved. This has resulted in a more consistent and maintainable codebase, which will make it easier to add new features and fix bugs in the future.

Additionally, the `heimdall-core` crate, which previously contained all the core modules, has been split into separate crates. For example, the `heimdall-decompiler` crate now contains the decompile module, `heimdall-disassembler` contains the disassemble module, and so on.

The main motivation behind this change was to make the codebase more modular, easy to maintain, and library-friendly. This will allow other rust projects to use heimdall's modules as standalone crates, without having to pull in the entire heimdall-rs project or hacking with the CLI. Additionally, the refactor was made with the goal of adhering to rust best practices, both in code style and efficiency.

Other noteworthy changes include:
 - Bifrost updates to support the new `crates` based architecture. This update is backwards compatible with all previous versions of heimdall. To update, simply run `bifrost -u`. **REQUIRED IF USING THE CLI**.
 - Extensive hardening of the codebase to prevent crashes and panics. Nearly all instances of `.unwrap()` have been removed, and error handling has been improved.
 - All logging is now done through the `heimdall-tracing` crate, and interfaces with the [tracing](https://docs.rs/tracing/latest/tracing/) crate.
 - All instances where `String`s were used to represend hex data have been replaced with `Vec<u8>` or `&[u8]` slices. This change was made to improve performance and reduce memory usage.

## Features and Improvements

In addition to the codebase improvements mentioned above, we've also added several new features to heimdall, as well as improved existing ones. Some of the most significant changes include:

### Support for Cancun/Deneb

As of 0.8.0, heimdall now supports all opcodes introduced in the Dencun hard fork. These include: `TLOAD`, `TSTORE`, `BLOBHASH`, `BLOBBASEFEE`, and `MCOPY`.

These new opcodes are fully supported in the disassemble and cfg modules, with partial support in the decompile module. Currently, solidity output for contract decompilation only fully supports `TLOAD` and `TSTORE`, while yul output is fully complete. We are actively working on adding full support for these opcodes, and expect to have this completed in the next release.

### Decode Improvements

The decode module has been significantly improved in this release. Some noteworthy changes include:

 - The new `--constructor` flag allows you to decode the constructor arguments of the given contract creation code. This flag will automatically parse, find, and decode the constructor arguments of the contract, and output them in a human-readable format. 
 
    **Note:** This feature is still experimental, and may not work for all contracts. We are actively working on improving this feature, and expect to have it fully functional in the next release.
 - We've removed an unnecessary sanity check that would greatly increase the time it took to decode a transaction. Previously, we would re-encode the decoded arguments and compare them to the original calldata in effort to remove false positives. This check used string comparison, and was the most costly step in the decode process. We've removed this check, and now only decode the arguments and filter out false positives based on signature and calldata heuristics.
 - Fixed an issue which caused the decode module to not output the decoded arguments if the verbosity was set to `0`. This issue has been fixed, and the decoded arguments will now be output regardless of the verbosity level (in the CLI only).

### Decompilation Improvements

The decompile module was not only completely rewritten, but significantly improved in this release. Here's whats changed:

 - The decompile module now supports all contracts, regardless of whether they were compiled with solc or not. Previously, the decompile module would only work with contracts compiled with solc, and would fail to decompile contracts compiled with other compilers.

    Contracts compiled with other compilers, such as vyper or huff, will write their decompiled output to the "fallback" function within the decompiled output. For example, here's the yul output for a cancun [vyper contract](https://sepolia.etherscan.io/address/0xc86e31922335cb94e508376de085d4fa85fecbba#code):

    ```yul
    object "DecompiledContract" {
        object "runtime" {
            code {

                function selector() -> s {
                    s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
                }

                function castToAddress(x) -> a {
                    a := and(x, 0xffffffffffffffffffffffffffffffffffffffff)
                }

                switch selector()
                default {
                    if xor(shr(0xe0, calldataload(0)), 0xfdf80bda) {
                        if or(callvalue(), lt(calldatasize(), 0x24)) {
                            if shr(0xa0, calldataload(0x04)) { revert(0, 0); } else {
                                mstore(0x40, calldataload(0x04))
                                if eq(0x02, tload(0)) { revert(0, 0); } else {
                                    tstore(0, 0x02)
                                    calldatacopy(msize(), 0, calldatasize())
                                    call(gas(), mload(0x40), 0, msize(), calldatasize(), 0, 0)
                                    if call(gas(), mload(0x40), 0, msize(), calldatasize(), 0, 0) { revert(0, 0); } else {
                                        returndatacopy(0, 0, returndatasize())
                                        tstore(0, 0x03)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    ```
 - Accuracy for type inference has been significantly improved. Previously, the decompile module would often fail to infer the correct type for certain variables. For example, lets compare the [WETH](https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) contract's ABI before and after 0.8.0:

    Expected:
    ```json
    {
        "type": "function",
        "name": "Unresolved_095ea7b3", // approve(address,uint256)
        "inputs": [
            {
                "name": "arg0",
                "type": "address"
            },
            {
                "name": "arg1",
                "type": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable"
    }
    ```

    0.7.3: 
    ```json
    {
        "Function": {
            "type": "function",
            "name": "Unresolved_095ea7b3", // approve(address,uint256)
            "inputs": [
                {
                    "name": "arg0",
                    "internalType": "bytes",
                    "type": "bytes"
                },
                {
                    "name": "arg1",
                    "internalType": "address",
                    "type": "address"
                }
            ],
            "outputs": [
                {
                    "name": "ret0",
                    "internalType": "bool",
                    "type": "bool"
                }
            ],
            "stateMutability": "nonpayable",
            "constant": false
        }
    }
    ```

    0.8.0: 
    ```json
    {
        "type": "function",
        "name": "Unresolved_095ea7b3", // approve(address,uint256)
        "inputs": [
            {
                "name": "arg0",
                "type": "address"
            },
            {
                "name": "arg1",
                "type": "uint256"
            }
        ],
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable"
    }
    ```

    **Note:** There is a known issue with type inference for storage and transient storage variables. We are actively working on improving this, and expect to have this fixed in the next release.

 - The decompile module now outputs `alloy_json_abi::JsonAbi` as it's ABI type, which removes the need for type conversion when working with other EVM libraries. This change was made to make it easier to integrate heimdall with other EVM tooling, and to make it easier to work with the decompiled output in general.

### Dump Improvements

The dump module has changed drastically in this release. The dump module no longer requires a `--transpose-api-key` to run, and will work off of `trace_replayBlockTransactions` alone. The dump module is now also significantly faster, since we replay entire blocks at a time, rather than individual transactions. 

Additionally, the TUI for this module has been removed, as it was a glorified CSV explorer and maintaining it was not worth the effort. The dump module still outputs a CSV file, which can be opened in any spreadsheet software.

### Support for MESC

[MESC](https://github.com/paradigmxyz/mesc) is a standard for how crypto tools configure their RPC endpoints. By following this specification, a user creates a single RPC configuration that can be shared by all crypto tools on their system.

In heimdall 0.8.0, we've added support for MESC-based RPC management and configuration.

### Cloud-based Decompilation

Thanks to [0xSha](https://twitter.com/0xsha), a new cloud-based decompilation tool has been built on top of heimdall-rs 0.8.0. If you're unable to run heimdall locally, or would like to decompile a contract without installing heimdall, you can use the cloud-based decompiler [here](https://web.heimdall.rs/).

## Bug Fixes

 - Various VM related bugs have been fixed, which caused heimdall to crash, panic, or hand when operating on certain contracts. 
 - Update default OpenAI model to `gpt-3.5-turbo-instruct` as the previous model was deprecated.
 - Fixed an issue where certain contract bytecode would not be recognized by the decompile module. This issue was caused by an incorrect assumption that the contract size would be limited to 25kb, which is not the case for other EVM-compatible chains.

## Sunsetting the `snapshot` Module

The snapshot module has been removed from the heimdall toolkit, as it didn't provide much value and was rarely used. The module was originally intended to provide a way to quickly analyze a contract's functions without having to decompile the entire contract. However, this module really was a stripped-down version of the decompile module, and was not very useful in practice.

The gas estimation feature (the only unique feature snapshot offered), will be moved to the decompile module in the next release, and will appear as a docstring comment in the decompiled output.

## Conclusion

The heimdall-rs 0.8.0 release is our largest update to date, with significant improvements to the codebase, new features, and bug fixes. We're excited to see how the community uses these new features, and look forward to your feedback.

As always, if you have any questions, comments, or suggestions, please feel free to reach out to us on [Telegram](https://t.me/heimdallsupport) or [GitHub](https://heimdall.rs)!