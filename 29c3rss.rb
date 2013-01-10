#!/usr/bin/ruby

require 'net/http'
require 'rss/maker'

class GetIndex
	#BASE = "http://ftp.halifax.rwth-aachen.de/CCC/27C3/mp4-h264-HQ/"
	BASE = "http://mirror.fem-net.de/CCC/29C3/mp4-h264-HQ/"
	TORRENTS = "/home/maege/Videos/ccc/torrent_files"

	def initialize
		path = File.join(File.expand_path(File.dirname(__FILE__)), "index.html")
		#html = File.open(path)
		html = Net::HTTP.get(URI.parse(BASE))
		old = 0
		new = 0
		downloaded = []
		Dir.new(TORRENTS).each { |file|
			downloaded << file.split(".added").first
		}
		html.split("\n").each { |line|
			if (data = line.match(/href="(.*)">(.*\.torrent)</))
				filename = File.basename(data[1])
				if (downloaded.include?(filename))
					puts "#{filename} already downloaded"
					old += 1
				else
					puts "downloading #{filename}..."
					url = URI.parse(File.join(BASE, data[1]))
					res = Net::HTTP.get_response(url)
					File.open(File.join(TORRENTS, filename), "wb") { |file|
						file.write(res.body)
					}
					new += 1
				end
			end
		}
		puts "Files old: #{old}, Files new: #{new}"
	end
end

GetIndex.new
