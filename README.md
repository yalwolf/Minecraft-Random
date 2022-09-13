# 随机

**Random** 是 Minecraft 1.17+ 的实用程序数据包，它添加了随机数生成和基于随机性的谓词的功能。

由 `[Aeldrion]`(https://github.com/Aeldrion)制作

[原版传送门](https://github.com/Aeldrion/Minecraft-Random)

## 函数

### `random:uniform`

使用线性同余生成器在 `$min` 和 `$max` 之间生成一个随机数。
生成的值被保存到分数 `$out`中。

```mcfunction
scoreboard players set $min random 0
scoreboard players set $max random 10
function random:uniform
```

注意：对于不除 ![2^31](https://render.githubusercontent.com/render/math?math=2^31) 的 `$max`-`$min`+1 的值，结果分布并不真正均匀 2^31)。
虽然这在几乎所有情况下都无关紧要，但 `random:true_uniform` 实现了一种对抗模数引起的偏差的方法。

![Generating 10000 numbers in range 0-10](https://cdn.discordapp.com/attachments/925818091475202118/926850852709359616/unknown.png)

### `random:binomial`

在给定参数 `$trials` 和 `$chance` 的情况下按照二项分布生成随机数。
生成的值被保存到分数`$out random`中。

```mcfunction
scoreboard players set $trials random 5
scoreboard players set $chance 500000
function random:binomial
```

![Generating 10000 numbers with n=5 and p=0.5](https://cdn.discordapp.com/attachments/925818091475202118/925820827851698236/unknown.png)

### `random:geometric`

根据给定参数`$chance`的几何分布生成一个随机数，每个伯努利试验的概率为 1,000,000,000。
{1, 2, 3, ...} 支持分发
生成的值被保存到分数`$out random`中。

```mcfunction
scoreboard players set $chance 400000000
function random:geometric
```

![Generating 10000 numbers with p=0.4](https://cdn.discordapp.com/attachments/925818091475202118/957630561965465610/unknown.png)

### `random:poisson`

使用 Poisson 分布生成一个随机数，给定期望值 `lambda`，比例为 10。
生成的值被保存到分数`$out random`中。

```mcfunction
scoreboard players set $lambda random 20
function random:poisson
```

![Generating 10000 Poisson variates with lambda=2.0](https://cdn.discordapp.com/attachments/925818091475202118/926851511345119262/unknown.png)

### `random:true_uniform`

使用线性同余生成器生成一个介于 `$min` 和 `$max` 之间的随机数，并消除模引起的偏差。
生成的值被保存到分数`$out random`中。
对于 `$min` 和 `$max` 的低值，偏差可以忽略不计，应该使用 `random:uniform` 来代替以提高效率。

```mcfunction
scoreboard players set $min random 1
scoreboard players set $max random 1000000000
function random:true_uniform
```

### `random:number_provider`

使用类似于数字提供程序的语法从存储中生成随机数。
`type` 可以是`constant`、`uniform`、`binomial`、`geometric`、`exponential` 或 `poisson`。
可以选择使用 `minecraft` 命名空间。
与普通数字提供程序一样，如果指定了 `min`/`max` 或 `n`/`p`，则可以省略 `type`。

对于 `constant` 类型，函数将返回参数 `value` 的值。

```mcfunction
# Constant
data merge storage random:input {type: "constant", value: 5}
function random:number_provider
```

对于 `uniform` 类型，该函数将返回参数 `min` 和 `max` （包括）之间的随机数。
只要指定了 `min` 和 `max`，`type` 是可选的。

```mcfunction
# Uniform
data merge storage random:input {type: "uniform", min: 1, max: 6}
function random:number_provider
```

对于`binomial`类型，该函数将返回一个随机数，该随机数遵循概率为`p`的`n`次试验的二项式分布。
只要指定了 `n` 和 `p`，`type` 是可选的。

```mcfunction
# Binomial
data merge storage random:input {type: "binomial", n: 10, p: 0.166666667d}
function random:number_provider
```

对于 `geometric` 类型，该函数将根据参数 `p` 的几何分布返回一个随机数。

```mcfunction
# Geometric
data merge storage random:input {type: "geometric", p: 0.2d}
function random:number_provider
```

对于 `poisson` 类型，该函数将返回期望值 `lambda` 的泊松变量。 与 `random:poisson` 不同，输入不需要比例。

```mcfunction
# Poisson
data merge storage random:input {type: "poisson", lambda: 5.0f}
function random:number_provider
```

### `random:choose`

从存储列表`random:input List`中选择一个随机标签并将其保存到存储标签`random:output Tag`中。

```mcfunction
data modify storage random:input List set value ["green", "yellow", "orange", "pink"]
function random:choose
tellraw @a {"nbt": "Tag", "storage": "random:output"}
```

## Predicates

### `random:coin_toss`

有 50% 的机会评估为真。

```mcfunction
execute if predicate random:coin_toss run say hi!
```

```mcfunction
# Simulating a coin toss
execute store result score <player> <objective> if predicate random:coin_toss
execute if score <player> <objective> matches 0 run say Heads
execute if score <player> <objective> matches 1 run say Tails
```

### `random:score_fraction`

以`$a`/`$b`的概率成功。

```mcfunction
scoreboard players set $a random 7
scoreboard players set $b random 12
execute if predicate:score_fraction run say 7/12
```

### `random:score_invert`

以 1/`$chance` 的概率成功。

```mcfunction
scoreboard players set $chance random 6
execute if predicate random:score_invert run say 1/6
```

### `random:score_percentage`

以百分比的概率`$chance`成功。 在 0 时，谓词总是失败； 在 100 时，它总是成功。

```mcfunction
scoreboard players set $chance random 5
execute if predicate random:score_percentage run say 5%
```

### `random:score_ppb`

以十亿分之几的概率 `$chance` 成功。 在 0 时，谓词总是失败； 在 1,000,000,000 时，它总是成功。

```mcfunction
scoreboard players set $chance random 123456789
execute if predicate random:score_ppb run say 12.3456789%
```

## 版本

此数据包专为 Minecraft：Java 版 1.17 设计，适用于 1.18 和 1.19 快照。
`pack.mcmeta` 中的数据包格式为 10，但您可以放心地将其降级为以前游戏版本中使用的数据包格式。

一些函数/谓词在 1.17 之前的版本中工作:

| 函数                 | 支持的版本                                |
|--------------------------|-----------------------------------------------------|
| `random:uniform`         | 1.13+                                               |
| `random:binomial`        | 1.17+                                               |
| `random:geometric`       | 1.17+                                               |
| `random:poisson`         | 1.13+                                               |
| `random:number_provider` | 1.15+, 1.17+ if `type` is `binomial` or `geometric` |

| 谓词                 | 支持的版本 |
|---------------------------|---------|
| `random:coin_toss`        | 1.15+   |
| `random:score_inverse`    | 1.17+   |
| `random:score_percentage` | 1.17+   |
| `random:score_ppb`        | 1.17+   |

Minecraft Random 不适用于 Minecraft：基岩版。

由`Google翻译`提供翻译
