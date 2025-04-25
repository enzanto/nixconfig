{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.vscode;
in {
    options.features.desktop.vscode.enable = mkEnableOption "enable vscode";

    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            extensions = with pkgs.vscode-extensions; [
                vscodevim.vim
                bbenoist.nix
                samuelcolvin.jinjahtml
                oderwat.indent-rainbow
                james-yu.latex-workshop
                ms-python.python
                ms-python.vscode-pylance
                streetsidesoftware.code-spell-checker
                jnoortheen.nix-ide
                ms-vscode-remote.remote-ssh
            ];
            userSettings = {
                "nix.serverPath" = "nixd";
                "git.autifetch" = true;
                "git.enableCommitSigning" = true;
                "nix.enableLanguageServer" = true;
                "nixpkgs" = {
                    "expr" = "import <nixpkgs> { }";
                };
                "formatting" = { 
                    "command" = [ "nixpkgs-fmt" ];
                };
                "zenMode.hideLineNumbers" = false;
                "zenMode.centerLayout" = false;
                "zenMode.showTabs" = "none";
                "editor.minimap.enabled" = false;
                "editor.lineNumbers" = "relative";
                # vim settings
                "vim.leader" = "<space>";
                "vim.normalModeKeyBindingsNonRecursive" = [
                    # switch between buffers
                    { 
                        before = ["<S-h>"];
                        "commands" = [":bprevious"];
                    }
                    { 
                        before = ["<S-l>"];
                        "commands" = [":bnext"];
                    }

                    #splits
                    { 
                        before = ["leader" "v"];
                        "commands" = [":vsplit"];
                    }
                    {
                        before = ["leader" "s"];
                        "commands" = [":split"];
                    }

                    # panes
                    {
                        before = ["leader"  "h"];
                        "commands" = ["workbench.action.focusLeftGroup"];
                    }
                    {
                        before = ["leader"  "j"];
                        "commands" = ["workbench.action.focusBelowGroup"];
                    }
                    {
                        before = ["leader"  "k"];
                        "commands" = ["workbench.action.focusAboveGroup"];
                    }
                    {
                        before = ["leader"  "l"];
                        "commands" = ["workbench.action.focusRightGroup"];
                    }
                    # NICE TO HAVE
                    {
                        before = ["leader"  "return"];
                        "commands" = ["python.execInTerminal-icon"];
                    }
                    {
                        before = ["leader"  "w"];
                        "commands" = [":w!"];
                    }
                        #{ before = ["leader", "q"], "commands": [":q!"] };
                    { 
                        before = ["leader"  "x"];
                        "commands" = [":x!"];
                    }
                    {
                        before = ["["  "d"];
                        "commands" = ["editor.action.marker.prev"];
                    }
                    {
                        before = ["]"  "d"];
                        "commands" = ["editor.action.marker.next"];
                    }
                    {
                        before = ["<leader>"  "c"  "a"];
                        "commands" = ["editor.action.quickFix"];
                    }
                    { 
                        before = ["leader"  "f"];
                        "commands" = ["workbench.action.quickOpen"];
                    }
                    { 
                        before = ["leader"  "p"];
                        "commands" = ["editor.action.formatDocument"];
                    }
                    {
                        before = ["g"  "h"];
                        "commands" = ["editor.action.showDefinitionPreviewHover"];
                    }
                ];
                "vim.visualModeKeyBindings" = [
                    # Stay in visual mode while indenting
                    { 
                        before = ["<"];
                        "commands" = ["editor.action.outdentLines"];
                    }
                    { 
                        before = [">"];
                        "commands" = ["editor.action.indentLines"];
                    }
                    # Move selected lines while staying in visual mode
                    { 
                        before = ["J"];
                        "commands" = ["editor.action.moveLinesDownAction"];
                    }
                    { 
                        before = ["K"];
                        "commands" = ["editor.action.moveLinesUpAction"];
                    }
                    # toggle comment selection
                    { 
                        before = ["leader" "c"];
                        "commands" = ["editor.action.commentLine"];
                        }
                ];
                "window.zoomLevel" = 1.5;
                "breadcrumbs.enabled" = false;
                "workbench.activityBar.location" = "hidden";
                "files.associations" = {
                    "*.yml" = "yaml";
                    "*.j2" = "yaml";
                };
                "[yaml]" = {
                    "editor.insertSpaces" = true;
                    "editor.tabSize" = 2;
                    "editor.autoIndent" = "advanced";
                    "diffEditor.ignoreTrimWhitespace" = false;
                };
            };
            keybindings = [
                {
                    key = "ctrl+shift+a";
                    command = "workbench.action.terminal.focusNext";
                    when = "terminalFocus";
                }
                {
                    key = "ctrl+shift+b";
                    command = "workbench.action.terminal.focusPrevious";
                    when = "terminalFocus";
                }
                {
                    key = "ctrl+shift+j";
                    command = "workbench.action.togglePanel";
                }
                {
                    key = "ctrl+shift+n";
                    command = "workbench.action.terminal.new";
                    when = "terminalFocus";
                }
                {
                    command = "workbench.action.toggleSidebarVisibility";
                    key = "ctrl+e";
                }
                {
                    command = "workbench.files.action.focusFilesExplorer";
                    key = "ctrl+e";
                    when = "editorTextFocus";
                }
                {
                    key = "n";
                    command = "explorer.newFile";
                    when = "filesExplorerFocus && !inputFocus";
                }
                {
                    command = "renameFile";
                    key = "r";
                    when = "filesExplorerFocus && !inputFocus";
                }
                {
                    key = "shift+n";
                    command = "explorer.newFolder";
                    when = "explorerViewletFocus";
                }
                {
                    command = "deleteFile";
                    key = "d";
                    when = "filesExplorerFocus && !inputFocus";
                }
                {
                    key = "ctrl+shift+5";
                    command = "editor.emmet.action.matchTag";
                }
                {
                    key = "ctrl+z";
                    command = "workbench.action.toggleZenMode";
                }
            ];
        };
    };
}
