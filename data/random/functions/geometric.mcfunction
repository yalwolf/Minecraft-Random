#> random:geometric
#
# 根据概率 p 的几何分布生成随机数，支持 {1, 2, 3, ...}
# Caps at 1000
#
# @public
# @input
#	score $chance random
#		The probability of success of each Bernoulli trial, with a scale of 1,000,000,000
# @output
#	score $out random
#		An integer in [1, 1000]

scoreboard players set $out random 0
function random:private/geometric_loop
