Bash Commands to help You Getting Started on Cloud
================

- <a href="#what-is-linux" id="toc-what-is-linux"><span
  class="toc-section-number">1</span> What is Linux?</a>
- <a href="#tools-to-communicate-with-linux-based-systems"
  id="toc-tools-to-communicate-with-linux-based-systems"><span
  class="toc-section-number">2</span> Tools to communicate with linux
  based systems</a>
- <a href="#task-specific-commands" id="toc-task-specific-commands"><span
  class="toc-section-number">3</span> Task specific commands</a>
  - <a href="#getting-the-basic-information"
    id="toc-getting-the-basic-information"><span
    class="toc-section-number">3.1</span> Getting the basic information</a>
  - <a href="#working-with-files-and-directories"
    id="toc-working-with-files-and-directories"><span
    class="toc-section-number">3.2</span> Working with files and
    directories</a>

# What is Linux?

The era of computing has come a long way, starting from the punch hole
card in 9999 to today’s cloud platforms, a significant progress has been
made. We are now habituated in using such cloud platforms. The most
popular example can be Google’s
[Colab](https://colab.research.google.com/), which has made cloud
computing available for all.

If you have ever used Google’s Colab, you are probably familiar with
Linux. It is the community driven operating system based on something
called *Linux Kernel* which powers devices starting from smart phones to
large cloud servers. So, the fact is knowingly or unknowingly we are
using devices in our daily lives which are powered by Linux Kernel.

The linux kernel was first developed by Linus Torvald in 1991 as a
personal hobby project and later it was made available publicly. You can
refer to this [article](https://en.wikipedia.org/wiki/Linux_kernel) to
know more on this.

In this post, I will be sharing some basic to intermediate linux
commands which will help you to start your journey with linux based
systems, may be on your personal computer or on a cloud platform.

**disclaimer:** I will be using a rendering engine called
[Quarto](https://quarto.org/) to develop this post as a GitHub flavored
markdown and it needs Python to run bash commands, that is why there is
`!` right before the actual bash command everywhere. `!` is not a part
of any bash command.

# Tools to communicate with linux based systems

In any form of linux based systems, the most basic tool to interact with
is the command line application a.k.a *Terminal*s, which is nothing but
an application equivalent to *cmd* on Windows, but much more powerful
than it. It is the application which accepts commands from the user and
performs the instructions accordingly.

Now, there is one more thing behind the story that is called shell.
Shell is the engine which parses the commands given by the user. There
are different types of shell. Typically, it is the bash shell where bash
stands for *Borne Again Shell*. Other shell applications available are
ZShell or Fish (*Friendly Interactive Shell*).

I will be runnning the commands using bash shell.

# Task specific commands

If you open the terminal anytime, typically you would see a prompt
ending with `:~$` and the cursor blinking next to it. It is now ready
for accepting commands from the user. The terminal usually points to a
directory on the system which, by default, is the user’s home directory
(i.e. the path `/home/<user>/`), which can be reconfigured to point to a
different location based on our need.

## Getting the basic information

#### :point_right: The `whoami` command

`whoami` is a command that returns the user name currently logged in.

``` python
!whoami
```

    koushik

#### :point_right: The `date` command

`date` gives you the current date and time.

``` python
!date
```

    Wed Mar 22 12:36:06 IST 2023

#### :point_right: The `pwd` command

`pwd` stands for the *present working directory* which is pointed out by
the terminal. For me the pwd is `/home/koushik/`

``` python
!pwd
```

    /home/koushik

#### :point_right: The `ls` command

`ls` stands for listing, which returns all the files and directories
(folders) availble inside the `pwd`.

``` python
!ls
```

    R                  bash-commands-for-cloud.qmd  microsoft-r-open
    bash-commands-for-cloud.ipynb  gems
    bash-commands-for-cloud.md     koushikkhan.github.io

Note that `ls` only returns the files and directories which are not
hidden, this is the default behavior of `ls`, if you want to see
something more you need some other options while using it, which are
often called flags.

I will use some flags below and try to explain what they mean.

**different flags of `ls`**

``` python
!ls -a
```

    .          .ipython           .vscode-server
    ..         .lesshsQ           .wget-hsts
    .bash_history  .lesshst           R
    .bash_logout   .local             bash-commands-for-cloud.ipynb
    .bashrc        .motd_shown        bash-commands-for-cloud.md
    .bundle        .profile           bash-commands-for-cloud.qmd
    .cache         .python_history        gems
    .config        .sudo_as_admin_successful  koushikkhan.github.io
    .gitconfig     .vscode-remote-containers  microsoft-r-open

`-a` flag is used for showing all the files and directories within `pwd`
including hidden ones. In linux hidden files are directories have `.` in
their names at the the very beginning.

``` python
!ls -h
```

    R                  bash-commands-for-cloud.qmd  microsoft-r-open
    bash-commands-for-cloud.ipynb  gems
    bash-commands-for-cloud.md     koushikkhan.github.io

`-h` flag is used for better representation for the users (human being,
that’s why `h`)

``` python
!ls -l
```

    total 48
    drwxr-xr-x  3 koushik koushik  4096 Mar 22 10:09 R
    -rw-r--r--  1 koushik koushik 10947 Mar 22 12:36 bash-commands-for-cloud.ipynb
    -rw-r--r--  1 koushik koushik 11906 Mar 22 12:32 bash-commands-for-cloud.md
    -rw-r--r--  1 koushik koushik  5897 Mar 22 12:36 bash-commands-for-cloud.qmd
    drwxr-xr-x 10 koushik koushik  4096 Mar 20 20:30 gems
    drwxr-xr-x 18 koushik koushik  4096 Mar 21 13:02 koushikkhan.github.io
    drwxr-xr-x  4 koushik koushik  4096 Mar 22 10:44 microsoft-r-open

`-l` flag is used for showing entries in a long format

``` python
!ls -t
```

    bash-commands-for-cloud.ipynb  microsoft-r-open       gems
    bash-commands-for-cloud.qmd    R
    bash-commands-for-cloud.md     koushikkhan.github.io

`-t` flag is used for showing entries sorted based on when they are
created

``` python
!ls -s
```

    total 48
     4 R                   4 gems
    12 bash-commands-for-cloud.ipynb   4 koushikkhan.github.io
    12 bash-commands-for-cloud.md      4 microsoft-r-open
     8 bash-commands-for-cloud.qmd

`-s` flag is used for showing the allocated sizes of the files

You can definitely combine multiple flags together just by putting the
next to each other like below and obviously you will get the combined
effect of them

``` python
!ls -lahts
```

    total 116K
     12K -rw-r--r--  1 koushik koushik  11K Mar 22 12:36 bash-commands-for-cloud.ipynb
    4.0K drwxr-xr-x 13 koushik koushik 4.0K Mar 22 12:36 .
    8.0K -rw-r--r--  1 koushik koushik 5.8K Mar 22 12:36 bash-commands-for-cloud.qmd
     12K -rw-r--r--  1 koushik koushik  12K Mar 22 12:32 bash-commands-for-cloud.md
    4.0K -rw-------  1 koushik koushik 3.1K Mar 22 10:49 .bash_history
    4.0K drwxr-xr-x  4 koushik koushik 4.0K Mar 22 10:44 microsoft-r-open
    4.0K drwxr-xr-x  3 koushik koushik 4.0K Mar 22 10:09 R
    4.0K drwxr-xr-x  3 koushik koushik 4.0K Mar 22 09:06 .ipython
    4.0K -rw-r--r--  1 koushik koushik 3.9K Mar 22 09:05 .bashrc
    4.0K drwxr-xr-x  6 koushik koushik 4.0K Mar 22 09:04 .local
    4.0K drwxr-xr-x  5 koushik koushik 4.0K Mar 22 09:03 .cache
    4.0K -rw-------  1 koushik koushik    7 Mar 22 09:02 .python_history
    4.0K drwx------  4 koushik koushik 4.0K Mar 22 08:57 .config
    4.0K -rw-r--r--  1 koushik koushik  165 Mar 22 08:52 .wget-hsts
       0 -rw-r--r--  1 koushik koushik    0 Mar 22 08:50 .motd_shown
       0 -rw-------  1 koushik koushik    0 Mar 21 20:32 .lesshsQ
    4.0K -rw-------  1 koushik koushik   20 Mar 21 20:08 .lesshst
    4.0K drwxr-xr-x 18 koushik koushik 4.0K Mar 21 13:02 koushikkhan.github.io
    4.0K drwxr-xr-x  5 koushik koushik 4.0K Mar 21 11:11 .vscode-server
    4.0K drwxr-xr-x  4 koushik koushik 4.0K Mar 21 10:27 .vscode-remote-containers
    4.0K -rw-r--r--  1 koushik koushik  129 Mar 20 20:58 .gitconfig
    4.0K drwxr-xr-x 10 koushik koushik 4.0K Mar 20 20:30 gems
    4.0K drwxr-xr-x  3 koushik koushik 4.0K Mar 20 20:29 .bundle
       0 -rw-r--r--  1 koushik koushik    0 Mar 20 19:58 .sudo_as_admin_successful
    4.0K -rw-r--r--  1 koushik koushik  807 Mar 20 19:58 .profile
    4.0K -rw-r--r--  1 koushik koushik  220 Mar 20 19:58 .bash_logout
    4.0K drwxr-xr-x  3 root    root    4.0K Mar 20 19:58 ..

One more thing to note here is that, you can use `ls` to see the
contents of any directory just by putting the path next to `ls` call
followed by a space character like below

``` python
!ls -lahts /
```

    total 2.0M
    4.0K drwxrwxrwt   7 root root 4.0K Mar 22 12:36 tmp
    4.0K drwxr-xr-x  80 root root 4.0K Mar 22 10:44 etc
    4.0K drwxr-xr-x   4 root root 4.0K Mar 22 10:44 opt
    4.0K drwx------   3 root root 4.0K Mar 22 10:44 root
       0 drwxr-xr-x   7 root root  140 Mar 22 08:52 run
    4.0K drwxr-xr-x  19 root root 4.0K Mar 22 08:50 .
    4.0K drwxr-xr-x  19 root root 4.0K Mar 22 08:50 ..
       0 drwxr-xr-x  11 root root 3.0K Mar 22 08:50 dev
       0 dr-xr-xr-x 202 root root    0 Mar 22 08:50 proc
       0 dr-xr-xr-x  11 root root    0 Mar 22 08:50 sys
    4.0K drwxr-xr-x   3 root root 4.0K Mar 20 19:58 home
    4.0K drwxr-xr-x   5 root root 4.0K Mar 20 19:57 mnt
     16K drwx------   2 root root  16K Mar 20 19:57 lost+found
    4.0K drwxr-xr-x   8 root root 4.0K Feb 11 03:06 snap
    4.0K drwxr-xr-x  13 root root 4.0K Feb 11 03:06 var
    4.0K drwxr-xr-x  14 root root 4.0K Feb 11 03:05 usr
    4.0K drwxr-xr-x   2 root root 4.0K Feb 11 03:05 media
    4.0K drwxr-xr-x   2 root root 4.0K Feb 11 03:05 srv
       0 lrwxrwxrwx   1 root root    7 Feb 11 03:05 lib -> usr/lib
       0 lrwxrwxrwx   1 root root    9 Feb 11 03:05 lib32 -> usr/lib32
       0 lrwxrwxrwx   1 root root    9 Feb 11 03:05 lib64 -> usr/lib64
       0 lrwxrwxrwx   1 root root   10 Feb 11 03:05 libx32 -> usr/libx32
       0 lrwxrwxrwx   1 root root    8 Feb 11 03:05 sbin -> usr/sbin
       0 lrwxrwxrwx   1 root root    7 Feb 11 03:05 bin -> usr/bin
    4.0K drwxr-xr-x   2 root root 4.0K Apr 18  2022 boot
    1.9M -rwxrwxrwx   1 root root 1.9M Jan  1  1970 init

Here `ls` is showing the contents of a special directory a.k.a `root`,
this is equivalent to the `C:\` drive on Windows.

#### :point_right: The `echo` command

`echo` evaluates an expression and prints that on the terminal.

``` python
!echo $(date)
```

    Wed Mar 22 12:36:07 IST 2023

here `date` is evaluated by echo and the output of echo is printed on
the terminal (or console).

Here is another example of `echo`.

``` python
!name="Julia" && \
echo "$name claims to be faster that Python"
```

    Julia claims to be faster that Python

there are two things to note here:

- we are creating a shell variable called `name` with the value `Julia`
  and this variable is referred in the `echo` call to print a formatted
  string on the console
- creation of `name` and calling `echo` are two separate commands which
  are being executed in a sequence by using `&&` operator a.k.a pipe
  operator. The `\` is used for breaking the lines to make the command
  flow through multiple lines.

## Working with files and directories

Now, you know the basics of running commands and getting some simple yet
useful information, it is the time to see a bit more interesting
commands.

#### :point_right: creating a file with \`\`

``` python
!echo "Hello"
```

    Hello
