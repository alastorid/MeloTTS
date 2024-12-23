@echo off
if not exist APPDATA (mkdir APPDATA)
if not exist hf_home (mkdir hf_home)
set TRANSFORMERS_CACHE=%~dp0hf_home
set HF_HOME=%~dp0hf_home
set APPDATA=%~dp0APPDATA

rem :: get python ready
rem if not exist python ( mkdir python )
rem if not exist python\_CACHE ( mkdir python\_CACHE )
rem path %~dp0python;%~dp0python\Scripts;%path%
rem set PIP_CACHE_DIR=%~dp0python\_CACHE

rem where python || (
rem 	pushd python &&(
rem 		curl -L -O -c - https://www.python.org/ftp/python/3.10.11/python-3.10.11-embed-amd64.zip
rem 		curl -L -O -c - https://bootstrap.pypa.io/get-pip.py
rem 		tar -xvf python-3.10.11-embed-amd64.zip
rem 		echo import site>>python310._pth
rem 		mkdir Lib\site-packages
rem 		(
rem 			echo import sys
rem 			echo import os
rem 			echo if os.getcwd^(^) not in sys.path:
rem 			echo     sys.path.insert^(0, os.getcwd^(^)^)
rem 		) > Lib\site-packages\sitecustomize.py
rem 		python get-pip.py
rem 		pip install setuptools wheel pip-system-certs certifi
rem 		popd
rem 	)
rem )
rem :: fixup
rem for /f "delims=" %%i in ('python -m certifi') do set "SSL_CERT_FILE=%%i"

:: get conda
if not exist conda (
	mkdir conda
	rem Miniconda3-latest-Windows-x86_64.exe <- big trouble
	rem Miniconda3-py310_24.11.1-0-Windows-x86_64.exe
	curl -L -O -c - https://repo.anaconda.com/miniconda/Miniconda3-py310_24.11.1-0-Windows-x86_64.exe
	Miniconda3-py310_24.11.1-0-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=%~dp0conda
	move Miniconda3-py310_24.11.1-0-Windows-x86_64.exe conda\
)
path %~dp0conda;%~dp0conda\Scripts;%path%

rem :: get git ready
rem 2>nul where git || path %path%;%~dp0git\bin
rem 2>nul where git || (
rem 	if not exist git ( mkdir git )
rem 	pushd git && (
rem 		curl -L -O -c - https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/PortableGit-2.47.1-64-bit.7z.exe
rem 		echo Extract PortableGit-2.47.1-64-bit.7z.exe to %~dp0git\
rem 		cmd /c PortableGit-2.47.1-64-bit.7z.exe -o. -y
rem 		popd
rem 	)
rem )
rem :: get MeloTTS ready
rem if not exist MeloTTS (
rem 	git clone https://github.com/myshell-ai/MeloTTS.git
rem )

pip show melotts || (
	pip install -e .
	pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
	python -m unidic download
	(
		echo import nltk
		echo nltk.download^('averaged_perceptron_tagger_eng'^)
	) > download_sth.py
	python download_sth.py
	del download_sth.py
	popd
)
