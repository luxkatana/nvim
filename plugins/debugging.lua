return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup {
          layouts = {
              {
                  elements = {
                      {id="console", size=0.5},
                      {id="watches", size=0.25},
                      {id="scopes", size=0.25},
                  },
                  size = 40,
                  position = "left"

              },
              {
                  elements = {
                      {id="repl", size=1},
                  },
                  size = 10,
                  position = "bottom"
              }

          }

      }
      require("nvim-dap-virtual-text").setup()

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/luxkatana/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "cppdbg",
          request = "launch",
          preLaunchTask = function()
              vim.fn.system("cargo build")
          end,
          program = function()
            return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "Enable Rust pretty-printing",
              ignoreFailures = true,
            },
          },
        },
      }


      vim.api.nvim_create_user_command("Debug", dap.continue, {})
      vim.keymap.set("n", "<F10>", function() dap.step_over() end)
      vim.keymap.set("n", "<F11>", function() dap.step_into() end)
      vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end)
      vim.keymap.set("n", "<Leader>dui", function() dapui.toggle() end)
    end,
  },
}

