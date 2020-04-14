#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import subprocess as cmd
cmd.call("python3 covid.ipynb")
cmd.call('jupyter nbconvert covid.ipynb --no-input --output "../../../../var/www/html/covid.html"')

