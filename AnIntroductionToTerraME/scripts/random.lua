
bernoulli = Random{p = 0.4}
print(bernoulli:sample()) -- a random boolean value

range = Random{min = 3, max = 7}
print(range:sample()) -- a value between 3 and 7

gender = Random{male = 0.49, female = 0.51}
print(gender:sample()) -- "male" (49%) or "female" (51%)

cover = Random{"pasture", "forest", "clearcut"}
print(cover:sample()) -- "pasture", "forest", or "clearcut" (each one has 33.33% of probability)
