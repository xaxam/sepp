#!/usr/bin/ruby
require 'open3'
require 'open-uri'
require 'rubygems'
require 'terminal-notifier'

$handle = 8

# Sente applescript one-line commands
def sente6(command)
	as = "osascript -e 'tell application \"Sente 6\" to " + command + "'"
	stdin, stdout, stderr = Open3.popen3(as)
	r = stdout.read
end

fp = '/Users/sx/Desktop/test.md'
fn = File.basename(fp,".*")
fback = File.join( File.dirname(fp), "#{fn}_bak.md" )

`cp #{fp} #{fback}`

# read and mark up {bibliography} for later use
File.open(fp) { |mdf| @md = mdf.read.gsub('{bibliography}','[--bib--]') }

# get all citation ids (as matchData, therefore enumerate and not just .scan )
cids = @md.to_enum(:scan, /\{.+?\}/).map { Regexp.last_match }

# get all inline references from Sente
inl = sente6('create bibliography elements current library from tags "' + cids.join('||').gsub(/[\{\}]/,'').gsub('\\', '\&\&') + '" for intext').split('||')
bib = sente6('create bibliography elements current library from tags "' + cids.join('||').gsub(/[\{\}]/,'').gsub('\\', '\&\&') + '" for bibliography')

# inverse arrays
cids = cids.reverse
inl = inl.reverse.drop(1)

log = []
err = []

if cids.count == inl.count 
	cids.to_enum.with_index.each { |cid, i| 
	
	# log this to allow for unscanning later
	# original citation id, formated inline citation, pre-match string (if formated in not unique)
	log << cid.to_s + '|' +  inl[i] + '|' + cid.pre_match.split(//).last($handle).join

	# through error if no match found
	err << cid.to_s if inl[i] == '()'

	# replace citation id with formated string, using the offsets in cids's matchData
	o = cid.offset(0)
	@md[(o[0])..(o[1] - 1)] = inl[i]

	}
end

if err.count > 0
	
	# notity
	@message = 'No match found for: ' + err.join(", ")
	TerminalNotifier.notify(@message, :title => "No bibliography produced...", :open => "http://www.something.com")
	
	
else
	# Write output file (with added bibliography)
	File.open(fp, 'w') {|f| f << @md.gsub('[--bib--]', bib.gsub('.<i> ','. *').gsub("<br>", "\n\n").gsub('<i>','*').gsub('</i>','*'))}

	# Write log file
	`mkdir -p "$HOME/Library/Application Support/sepp"`
	File.open(ENV["HOME"] + '/Library/Application Support/sepp/' + fn + '.log', 'w') {|f| f << log.join("\n")}

	#notify
	@message = 'Inline: ' + inl.count.to_s + '; References: ' + bib.gsub("<br>", "\n").lines.count.to_s + '.'
	TerminalNotifier.notify(@message, :title => "Successfully produces bibliography", :open => "http://www.something.com")
	
end
