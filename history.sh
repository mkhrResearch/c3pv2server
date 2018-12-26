#History settings
PROMPT_COMMAND='echo -e "res:$?\tpwd:`pwd`\tdate:`date +%s`\t" >> ~/.bash_history;history -a'