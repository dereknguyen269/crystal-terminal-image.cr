BLOCK = "\x1b[48;5;%dm\x1b[38;5;%dm%5s\x1b[0m"
BLACK = 0
WHITE = 15

def get_block(bgcolor, fgcolor=0)
  return BLOCK % [bgcolor, fgcolor, bgcolor.to_s]
end

puts "System colors:"

(0..7).each do |c|
 printf get_block(c, WHITE)
end
printf "\n"

(8..15).each do |c|
 printf get_block(c, BLACK)
end
printf "\n"

puts "Other Colors:"
(16..231).each_slice(12) do |cs|
 cs.each do |c|
  printf get_block(c, c <= 27 ? WHITE : BLACK)
 end
 printf "\n"
end

puts "Grays:"

(232..243).each do |c|
 printf get_block(c, WHITE)
end
printf "\n"

(244..255).each do |c|
 printf get_block(c, BLACK)
end

printf "\n"
