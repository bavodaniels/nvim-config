return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      -- Auto open/close the debug UI
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", numhl = "" })

      local map = vim.keymap.set
      -- IntelliJ-like debug keys (F-keys)
      map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      map("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
      map("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
      map("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
      map("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional breakpoint" })
      map("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
      map("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
      map("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
      map("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
    end,
  },
}
