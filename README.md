# GitVersion
> Transformer to replace %version%-String in your .html or .dart-Files with the current GIT-Version
 
## Precondition 

    # Init your GIT repo
    git init
    
    # Add your repo
    git remote add origin <your repo>
         
    # Make your first commit
    git commit -am "Initial release"
    
    # Tag your version
    git tag v0.1
    
    # Install showGitVersion cmdline tool
    pub global activate git_version

## Usage

### Transformer
Your pubspec.yaml:

    ```yaml
    ...
    dev_dependencies:
      git_version: any
    
    transformers:
      - git_version
    ```

Your index.html:

    ```html
    <body>Version %version%</body>
    ```
    
Now build your App:

    pub build    
    
### Commandline

    # Go to your local repo
    showGitVersion
    
    # Print help
    showGitVersion --help
     

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MikeMitterer/dart-git_version

## Licence

    Copyright 2016 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited
    
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of the <organization> nor the
          names of its contributors may be used to endorse or promote products
          derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


