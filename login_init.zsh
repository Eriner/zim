

#
# startup file read in interactive login shells
#
# The following code helps us by optimizing the existing framework.
# This includes zcompile, zcompdump, etc.
#

(
  local dir file
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  autoload -U zrecompile

  # zcompile the completion cache; siginificant speedup
  zrecompile -pq ${ZDOTDIR:-${HOME}}/${zcompdump_file:-.zcompdump}

  # zcompile .zshrc
  zrecompile -pq ${ZDOTDIR:-${HOME}}/.zshrc

  # zcompile enabled module autoloaded functions
  for dir in ${ZIM_HOME}/modules/${^zmodules}/functions(/FN); do
    zrecompile -pq ${dir}.zwc ${dir}/^([_.]*|prompt_*_setup|README*|*.zwc|*.zwc.old)(-.N)
  done

  # zcompile enabled module init scripts
  local zmodule
  for zmodule (${zmodules}); do
    local zmodule_dir=${ZIM_HOME}/modules/${zmodule}
      if [[ -d ${zmodule_dir} ]]; then
        for zmodule_file (${zmodule_dir}/{,zsh-}${zmodule}.zsh-theme \
            ${zmodule_dir}/init.zsh \
            ${zmodule_dir}/{,zsh-}${zmodule}.plugin.zsh \
            ${zmodule_dir}/{,zsh-}${zmodule}.{z,}sh); do
           if [[ -f ${zmodule_file} ]]; then
             zrecompile -pq ${zmodule_file}
             break
           fi
         done
      fi
  done
  # zcompile all prompt setup scripts
  for file in ${ZIM_HOME}/modules/prompt/functions/prompt_*_setup; do
    zrecompile -pq ${file}
  done

  # syntax-highlighting
  for file in ${ZIM_HOME}/modules/syntax-highlighting/external/highlighters/**^test-data/*.zsh; do
    zrecompile -pq ${file}
  done
  zrecompile -pq ${ZIM_HOME}/modules/syntax-highlighting/external/zsh-syntax-highlighting.zsh

  # zsh-histery-substring-search
  zrecompile -pq ${ZIM_HOME}/modules/history-substring-search/external/zsh-history-substring-search.zsh

) &!
