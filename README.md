# GitVersion
> Builder to replace %version%-String in index.tmpl.html and version.tmpl.json. 
> Generates git.version.dart

## Important
If your version schema should have three digits (e.g. v.1.0.0),   
tag it only with two digits e.g. `git tag v1.0` and let `GitVersion` do the the rest.

`GitVersion` counts the commits for a specific version tag and adds the number of
commits as the last digit. 

`git_version` uses [`git describe --tags --match <tag>`](https://git-scm.com/docs/git-describe) for this.  
  
## Precondition 

    # Init your GIT repo
    git init
    
    # Add your repo
    git remote add origin <your repo>
         
    # Make your first commit
    git commit -am "Initial release"
    
    # Tag your version
    git tag v0.1
    
Optional - if you want to use `showGitVersion` on the cmdline

    # Install showGitVersion cmdline tool
    pub global activate git_version

## Usage

### Builder
> [Try the mini_web_sample](https://github.com/MikeMitterer/mini_web_sample)

Run the following command:

    pub run build_runner clean && pub run build_runner build
    
Serve your site:

    webdev serve
    
What the builder does:

   - If it finds `index.tmpl.html` in your web-folder 
   it replaces `%version%` with the current version from git and converts the
   file to `index.html`
   
   - If it finds `version.tmpl.json` in your web-folder
   it replaces `%version%` with the current version from git and converts 
   the file to `version.json`
   
   - It generates `git.version.dart` in your web-folder
   
The file conversion to `index.html` and `version.json` happens in your "build-output".  
This is usually something like: `.dart_tool/build/generated/<your package>`   
            
### Commandline

    # Go to your local repo
    showGitVersion
    
    # Print help
    showGitVersion --help
     

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MikeMitterer/dart-git_version

## Licence

    Copyright 2018 Michael Mitterer (office@mikemitterer.at),
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
