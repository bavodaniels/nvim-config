return {
  -- nvim-dap is the generic Debug Adapter Protocol *client* for Neovim. It
  -- knows how to talk to a debug adapter, manage breakpoints, and step through
  -- code -- but it needs a language-specific adapter to actually do anything.
  -- For Java, nvim-jdtls wires jdtls + java-debug-adapter into nvim-dap for us
  -- (see java.lua's on_attach -> setup_dap). Here we just configure the UI and
  -- the keymaps that drive a debug session.
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Make breakpoints and the current line visible in the sign column.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "" })

      -- Debug controls. These work for any language once its adapter is set up.
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })

      -- Logpoint: non-blocking breakpoint that prints a message instead of
      -- pausing. Expressions inside {curly braces} are evaluated in the
      -- program's context, e.g. "message = {message}, len = {message.length()}".
      vim.keymap.set("n", "<leader>bl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "DAP: set logpoint" })

      vim.keymap.set("n", "<F9>", dap.continue, { desc = "DAP: start / continue" })
      vim.keymap.set("n", "<F8>", dap.step_over, { desc = "DAP: step over" })
      vim.keymap.set("n", "<F>", dap.step_into, { desc = "DAP: step into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: open REPL" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: terminate session" })

      -- Inspect the variable under the cursor while paused.
      vim.keymap.set({ "n", "v" }, "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "DAP: hover value" })
    end,
  },

  -- nvim-dap-ui adds a sidebar (variables, watches, call stack, breakpoints)
  -- plus a REPL/console panel, giving you a full graphical debugger layout.
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- required async runtime for dap-ui
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Open the UI automatically when a session starts, close it when the
      -- session ends. `event_terminated` / `event_exited` fire when the
      -- debuggee finishes or you terminate it.
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Toggle the UI manually if you want to reopen it after it closes.
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: toggle UI" })
    end,
  },
}
