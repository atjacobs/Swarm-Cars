#!/usr/bin/python
"""
Alex Jacobs, 2013

This script simulates the behavior of swarming (or flocking) agents using
the "Dubins" vehicle.  The dubins vehicle can be described with a 3D state vector:

X = [x, y, theta]
and
X_dot = [V*cos(theta),V*sin(theta),u],

Where

V = the constant forward trajectory of the vehicle
u = the single control input

N vehicles, or "agents", are coupled to each other s.t. they seek a finite distance from one another.
"""

from numpy import *
import pylab as p
from scipy import integrate
import scipy.linalg
import pdb

""" 
First let's define the forcing function that determines the ideal distance.  It should:

1. Repel when close,
2. Attract when farther than the ideal distance
3. Attract less as distance increases, so as to not compress a group.

So if describing a potential energy function, it should be like a Van der Waals potential.
"""

# Some simulation parameters.
V = 1         		# Velocity
runTime = 30;   	# Time to run simulation
N = 2 				# number of agents
X0 = random.rand(3*N)	#ICs 
minTurningRadius = .5
maxThetaDot = V/minTurningRadius

ALPHA = .9
BETA = .5
OFFSET = .75

def scalingFunction(r):
	d = sqrt(dot(r,r))
	# This function meets all the criteria above.
	return -1*exp(-ALPHA*d)*(40*(d-OFFSET))

distance = linspace(0,10,50)
force = zeros(shape(distance))

for index in range(len(distance)):
	force[index] = scalingFunction(distance[index])

f1 = p.figure()
p.plot(distance, force, 'r-')
p.grid()
p.xlabel('distance')
p.ylabel('force')
p.title('Forcing function.')
f1.savefig('forcing_function.png')

def trimControlInput(controlInput):
	if controlInput > maxThetaDot:
		return maxThetaDot
	elif controlInput < -1*maxThetaDot:
		return -1*maxThetaDot
	else:
		return controlInput

def f1(X,t=0):
	""" Returns he first derivative of the system
	"""
	dX_dt = zeros(3*N)
	for agentIndex in range(N-1):
		# Calculate the desired direction for the agent.
		force = zeros((1,2))
		for otherAgentIndex in range(N):
			if agentIndex == otherAgentIndex:
				continue
			r = X[3*agentIndex:3*agentIndex+2] - X[3*otherAgentIndex:3*otherAgentIndex+2]
			rNorm = sqrt(dot(r,r))
			force +=  r/rNorm * scalingFunction(rNorm)
		# print "Force vector:", force
		# We now have a "desired direction" vector.
		# Let's do a simple sliding mode controller:
		# The control input will simply be the max turning rate thrown
		# Times the sign of the error signal
		forceAngle =  arctan2(force[0,1],force[0,0])
		headingError = forceAngle - X[3*agentIndex+2]
		# print "forceAngle:", forceAngle*180/pi
		# print "headingError", headingError*180/pi
		dX_dt[3*agentIndex:3*agentIndex+3] = [V*cos(X[3*agentIndex + 2]),
		V*sin(X[3*agentIndex+2]),
		BETA*headingError];
		# maxThetaDot*sign(headingError)]
		#print "Control input:", maxThetaDot*sign(headingError)
	dX_dt[-3:] = [0*V*cos(X[-1]),0*V*sin(X[-1]),0]
	print "dX_dt:", dX_dt
	return dX_dt

# X0 = array([0,0,pi/4,1,1,pi/10])

# print f1(X0)

numberOfAngles = 10
fangle = p.figure()
p.title("Forcing angle")
for angleIndex in range(numberOfAngles):
	leaderLocation = array([2*cos(angleIndex*2*pi/numberOfAngles),2*sin(angleIndex*2*pi/numberOfAngles)])
	print "leaderLocation", leaderLocation
	X0 = array([0,0,0,leaderLocation[0],leaderLocation[1],0])
	f = f1(X0)
	print "control input", f[2]
	p.plot(array([angleIndex*2*pi/numberOfAngles*180/pi]), array([f[2]]),"bo")
# p.show()

# Integrate the system.
X0 = array([0,0,0,5,10,0])
t = linspace(0,runTime,200)
X, infodict = integrate.odeint(f1, X0, t, full_output=True)
print infodict['message']

print "leader locations", X[:,0:1]

# Plot the trajectories.
f1 = p.figure()
for ind in range(0,N):
 	p.plot(X[:,3*ind],X[:,3*ind+1],'-rx', label=str(ind))
p.grid()
p.legend(loc="best")
p.xlabel('x')
p.ylabel('y')
# p.xlim([0,.5])
# p.ylim([0,.5])
p.title('Trajectory of agents.')
p.show()
# f1.save("Trajectories_dubins.png")
