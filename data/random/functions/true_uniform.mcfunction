#> random:true_uniform
#
# 使用线性同余生成器在两个给定边界之间生成一个随机数
# 调整模偏差：如果范围很小，或者如果 max-min 几乎整除 2147483648，则偏差不应该很明显，应该使用 random:uniform 来提高效率
#
# @public
# @input
#	score $min random
#		The minimum value (inclusive)
#	score $max random
#		The maximum value (inclusive)
# @output
#	score $out random
#		An integer in range [min, max]

# Calculate size of range
scoreboard players operation #size random = $max random
scoreboard players operation #size random -= $min random
scoreboard players add #size random 1

# Calculate maximum authorised value
scoreboard players set #max random 2147483647
scoreboard players operation #max random /= #size random
scoreboard players operation #max random *= #size random

# Loop
function random:private/true_uniform_loop
scoreboard players operation $out random = #lcg random

# Get within desired range
scoreboard players operation $out random %= #size random
scoreboard players operation $out random += $min random
