# json_compressor

provides a transformer that compresses json files

## Usage

json_compressor provides two parameters: 'debugMode' and 'prodMode', both are optional.

    dev_dependencies:
      json_compressor: ^1.0.0
    transformers:
    - json_compressor:
        debugMode: indent1
        prodMode: no_indent

#### possible values (for both)
 - **off**: don't change the json files (this is also the fallback, if an illegal value was provided)
 - **single_row**: compress json file to a singleline version without spaces or newlines
 - **no_indent**: compress json file to a multiline version without indentation/spaces
 - **indent1**: compress json file to a multiline version with one space indentation per level
 - **indent2**: compress json file to a multiline version with two spaces indentation per level
 - **indent4**: compress json file to a multiline version with four spaces indentation per level
 
#### default values
 - **debugMode**: no_indent
 - **prodMode**: single_row
 