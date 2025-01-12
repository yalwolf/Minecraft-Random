#> random:binomial
#
# 使用循环上的 value_check 谓词生成具有参数 n、p 的二项式分布的随机数
#
# @public
# @input
#	score $trials random
#		The number of Bernoulli trials. Maximum accepted value is 1000. Otherwise, output is 0.
#	score $chance random
#		The probability of success of each Bernoulli trial, with a scale of 1,000,000,000.
# @output
#	score $out random
#		An integer in [0, n]

scoreboard players operation #trials random = $trials random
scoreboard players set $out random 0
execute if score $trials random matches 1..1000 if score $chance random matches 1..1000000000 run function random:private/binomial_loop
scoreboard players reset #trials random
