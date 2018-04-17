from sage.doctest.util import Timer
import time

class Zero(object):
	"""docstring for Zero"""
	def __init__(self, n):
		super(Zero, self).__init__()
		self.n = n
		self.g, self.p = self.pick_g_p()

	def pick_g_p(self):
		set_random_seed()
		s = initial_seed() % 4
		p = seed_list[s][0]
		set_random_seed()
		t = initial_seed() % (len(seed_list[s])-1) + 1
		g = seed_list[s][t]
		return g,p

class Verifier(object):
	"""docstring for Verifier"""
	def __init__(self, instance):
		super(Verifier, self).__init__()
		self.instance = instance
		self.y = 0

	def __call__(self, y):
		self.y = y

	def verify_round(self, prover):
		rand = make_random_number(2)
		prover()
		if rand == 0:
			return (prover.c == (self.instance.g**prover.verification_value(rand) % self.instance.p))
		else:
			return ((self.y * prover.c) % self.instance.p == (self.instance.g**prover.verification_value(rand) % self.instance.p))

class Prover(object):
	"""docstring for Prover"""
	def __init__(self, instance):
		super(Prover, self).__init__()
		self.instance = instance
		self.x = make_random_number(self.instance.p)
		self.y = self.calc_discrete_log(self.x, self.instance.g, self.instance.p)
		self.r = 0
		self.c = 0

	def __call__(self):
		self.r = make_random_number(self.instance.p)
		self.c = self.calc_discrete_log(self.r, self.instance.g, self.instance.p)

	def calc_discrete_log(self, e,g,p):
		a = g**e % p
		return a
		
	def verification_value(self,n):
		if n == 0:
			return self.r
		else:
			return self.calc_discrete_log(1,(self.x + self.r), (self.instance.p - 1))

def make_random_number(m): #m is the range
	set_random_seed()
	s = initial_seed() % (m)
	return s

if __name__ == "__main__":
	seed_list = [[105517,70704,85632,60620,87444,67610,80647,101855,54965,41621,61492], [111373,69332,27443,104892,93100,64626,71496,68251,33385,76576,107190],
[128657,32730,62217,87354,71602,75569,47213,128617,117564,38579,18101],
[135697,59814,116543,103543,75109,59260,68314,105217,35194,11509,58049]]

	x = 'Authentication Successful!'
	n = input('Enter the number of rounds to verify: ')
	instance = Zero(n)
	confidence = 1.0

	peggy = Prover(instance)
	victor = Verifier(instance)
	victor(peggy.y)
	
	timer = Timer().start()
	for round in range(instance.n):
		peggy()
		if victor.verify_round(peggy):
			confidence = confidence * (0.5)
		else:
			print 'Peggy doesn’t know shit! @ round ', round
			x = 'Authentication Failure!'
			break
	print x
	timer.stop()
	print timer
	if x != 'Authentication Failure!':
		print 'The confidence that peggy knows x after',  n, 'rounds is', 1-confidence
