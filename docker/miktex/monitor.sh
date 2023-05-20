#!/bin/bash
# check if inotifywait is installed and install it if not
if ! [ -x "$(command -v inotifywait)" ]; then
	echo 'Error: inotifywait is not installed.' >&2
	apt-get update
	apt-get install -y inotify-tools
fi

start_listening() {
	inotifywait -m /miktex/work/tex/ -e create -e moved_to |
		while read dir action file; do
			echo "The file '$file' appeared in directory '$dir' via '$action'"
			pdflatex -interaction=nonstopmode /miktex/work/tex/$file -output-directory /miktex/work/pdf/
			rm /miktex/work/tex/$file
			## delete everything in the pdf folder except the pdf file
			find /miktex/work/pdf/ -type f ! -name '*.pdf' -delete
			## chmod the pdf file to 777
			chmod 777 /miktex/work/pdf/*.pdf
		done
start_listening
}
start_listening

