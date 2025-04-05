This is an example of how to run the https://github.com/chrishayuk/mcp-cli within a container for testing, using Podman.

For use with an NVIDIA GPU with the NVIDIA container toolkit installed and configured for use with Podman.  

Clone this repository:
`git clone https://github.com/ai-local/mcp-cli-container.git`

If running rootless Podman, enable the container_use_devices SELinux boolean:  
`sudo setsebool -P container_use_devices=true`

Build container with: 
`podman build . --tag mcp-cli --device nvidia.com/gpu=all`

Run container with:   
`podman run --device nvidia.com/gpu=all --name mcp-cli -it mcp-cli /bin/bash`

Within container, run the following to start ollama and download a model of your choice:

```
ollama serve >/dev/null 2>&1  &
ollama list
ollama pull granite3.2:8b-instruct-q8_0
```

Within container, configure MCP server servers in the `server_config.json` file.  In this example, I'll configure MCP servers from https://github.com/MladenSU/cli-mcp-server and https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

Note: these MCP servers are configured below to provide full access to the root directory and the ability to run any command, with any command flag.  Update this configuration as needed if you would like to restrict what the MCP servers have access to:

```
    "cli-mcp-server": {
      "command": "uvx",
      "args": [
        "cli-mcp-server"
      ],
      "env": {
        "ALLOWED_DIR": "/",
        "ALLOWED_COMMANDS": "all",
        "ALLOWED_FLAGS": "all",
        "MAX_COMMAND_LENGTH": "1024",
        "COMMAND_TIMEOUT": "30"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/"
      ]
    }
```

Run `mcp-cli` and specify the server you would like to use (run twice if it doesn't recognize the MCP server the first time).  For cli-mcp-server example:
`mcp-cli chat --server cli-mcp-server --provider ollama --model granite3.2:8b-instruct-q8_0`

For filesystem example (run twice if it doesn't recognize the MCP server the first time):
`mcp-cli chat --server cli-mcp-server --provider ollama --model granite3.2:8b-instruct-q8_0`
