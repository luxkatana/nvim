return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      {"zbirenbaum/copilot.lua", config=function()
          require"copilot".setup{}
      end},
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    config = true,
    build = "make tiktoken", -- Only on MacOS or Linux
  },
}
