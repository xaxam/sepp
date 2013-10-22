#!/usr/bin/ruby
require 'open3'
require 'open-uri'
require 'rubygems'
require 'terminal-notifier'

# process filenames
fp = '/Users/sx/Desktop/test.md'
fn = File.basename(fp,".*")
lg = ENV["HOME"] + '/Library/Application Support/sepp/' + fn + '.log'
fback = File.join( File.dirname(fp), "#{fn}_bak.md" )

`cp "#{fp}" "#{fback}"`

# read and mark up {bibliography} for later use
File.open(fp) { |mdf| @md = mdf.read }
File.open(lg) {|f| @log = f.read.split("\n")}

err = []

@log.each { |ref| 

	e = ref.split('|')
	n = @md.scan(e[1]).count

	if n == 1
		# one matching string found. Proceed, replace
		@md.sub!(e[1], e[0])
	
	elsif n > 1
		# not unique, try with match_pre data
		x = @md.scan(e[2] + e[1]).count
	
			if x == 1
			@md.sub!(e[2] + e[1],  e[2] + e[0])

			elsif x > 1
				#still not unique. Mark both?
				err << e
			else
				# nothing found. Inline ref still there, but match_pre changed. Use last?
				err << e
			end
	
	else
		# no matching inline reference found. Inline ref probably deleted...
		err << e
	end

}

File.open(fp, 'w') {|f| f << @md}

if err == []
`rm -f "#{lg}"`
else
 File.open(lg, 'w') {|f| f << err.join("\n")}
end 




