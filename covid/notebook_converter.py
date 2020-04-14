#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import subprocess as cmd
cmd.run("python covid.ipynb")
cmd.run('jupyter nbconvert covid.ipynb --no-input --output "../../../../var/www/html/covid.html"')
cmd.run("")

