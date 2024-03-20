param map = localPath('../maps/CARLA/Town01.xodr')
param carla_map = 'Town01'
param render = '0'
model scenic.simulators.carla.model

EGO_SPEED = 10

V2_MIN_SPEED = 1
THRESHOLD = 15

monitor StopAfterTimeInIntersection:
    totalTime = 0
    while totalTime < 1000:
        totalTime += 1
        wait
    terminate

behavior Vehicle2Behavior(min_speed=1, threshold=10):
    while (ego.speed <= 0.1):
        wait
    try:
        do CrossingBehavior(ego, min_speed, threshold)
    interrupt when withinDistanceToAnyCars(self, 10) or ego.speed == 0:
        do FollowLaneBehavior(EGO_SPEED)

lane = Uniform(*network.lanes)

spot = OrientedPoint on lane.centerline

ego = Car following roadDirection from spot for -10-Range(0, 10),
    with blueprint "vehicle.bmw.grandtourer",
    with rolename "hero"
vehicle2 = Car left of spot by 2,
    with blueprint "vehicle.carlamotors.carlacola",
    with heading -30 deg relative to spot.heading,
    with regionContainedIn None,
    with behavior Vehicle2Behavior(V2_MIN_SPEED, THRESHOLD)

require (distance to intersection) > 30
terminate when (distance to spot) > 100 or (distance to vehicle2) > 50
# "This accident report involves a multi-vehicle crash that occurred during the early morning hours on an urban non-lighted multi-lane interstate. The primary event in this crash involved a severe override impact to the rear plane of a 2011 Ford Fusion by the front plane of a 2013 Freightliner tractor/trailer, followed by an underride impact with the frontal plane of Vehicle 1 and the rear plane of a 2016 Freightliner tractor/trailer. There was also an initial impact between the front plane of the 2013 Freightliner and the rear plane of a 2002 Ford Explorer.\n\nThe driver of Vehicle 1, a 68-year-old female, was traveling in the far-right westbound travel lane approaching traffic congestion at an interchange area. Vehicles 2, 3, and 4 were also traveling westbound in this lane. As vehicles slowed due to traffic congestion, Vehicle 2 failed to slow down and collided with Vehicle's frontal side causing it to move into another travel lane before striking Vehicle's rear end. \n\nAfter these collisions, all vehicles came to rest in the far-right travel lane with disabling damage. The weather conditions at the time were foggy and road surface was dry with no lighting present on this part of interstate. Vehicles involved included two Freightliner tractor/trailers (Vehicle's) , one Ford Fusion sedan (Vehicle),and one Ford Explorer compact utility vehicle (Vehicle). All three towed from scene due to disabling damages while only vehicle could be driven from site after minor repairs.\n"