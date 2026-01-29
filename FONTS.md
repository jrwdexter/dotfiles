# Fonts

CascadiaCove
icomoon
Monaspice
typicons.font
hack
JetBrainsMono
material-design-icons
SpaceMono

## Install

Fonts can be quickly installed iwth:

```bash
yay -S \
  ttf-cascadia-code-nerd \
  ttf-icomoon-feather \
  otf-monaspace-nerd \
  ttf-typicons \
  ttf-hack-nerd \
  ttf-jetbrains-mono-nerd \
  otf-material-design-icons \
  ttf-space-mono-nerd
```

## Special Banana () Considerations

Note that some of my files expect an MJL font, which has a patched banana into the font system. That requires using the MJL NerdFonts repo and installing those fonts directly (for example, into `~/.fonts`).

Otherwise, remove the banana from `.p10k.zsh`.
