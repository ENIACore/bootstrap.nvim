return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	capabilities = {
		-- Disable everything except hover
		definitionProvider = false,
		referencesProvider = false,
		documentSymbolProvider = false,
		workspaceSymbolProvider = false,
		completionProvider = false,
		signatureHelpProvider = false,
		renameProvider = false,
		codeActionProvider = false,
		codeLensProvider = false,
		documentFormattingProvider = false,
		documentRangeFormattingProvider = false,
		diagnosticProvider = false,
	},
}
