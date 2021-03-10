# sudo-parser

This repository contains a tool to parse complex sudoers configurations, highlighting possible security misconfigurations.

To use this tool:

```./sudo-parse.pl /path/to/sudoers```

More complicated uses are also possible. For example, to use it to drive [t0thkr1s](https://github.com/t0thkr1s)'s [gtfo](https://github.com/t0thkr1s/gtfo):

```
./sudo-parser.pl /etc/sudoers | grep "E:" | grep -v "ALL" | cut -f 2 -d " " | cut -f 2 -d: | while read commandname
do
  ./gtfo.py "$(basename "${commandname}")"
done
```

For any queries about the contents of this repository please contact [Security Advisory EMEAR](mailto:css-adv-outreach@cisco.com).
