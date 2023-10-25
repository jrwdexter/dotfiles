vim.g.coq_settings = { auto_start = true }
return {
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
  },
  { "ms-jpq/coq.artifacts", branch = "artifacts" },
  { "ms-jpq/coq.thirdparty", branch = "3p" },
}
