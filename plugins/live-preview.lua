return {
    "brianhuster/live-preview.nvim",
    config = function()
        require("livepreview.config").set {
            port = 8000,
        }
    end
}
