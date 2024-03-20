param map = localPath('../maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
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
    do FollowLaneBehavior(EGO_SPEED)

lane = Uniform(*network.lanes)

spot = OrientedPoint on lane.centerline

ego = Car following roadDirection from spot for -20,
    with blueprint "vehicle.tesla.model3",
    with rolename "hero"
vehicle2 = Car left of spot by 3,
    with blueprint "vehicle.charger2020.charger2020",
    with heading -180 deg relative to spot.heading,
    with regionContainedIn None,
    with behavior Vehicle2Behavior(V2_MIN_SPEED, THRESHOLD)

require (distance to intersection) > 50
terminate when (distance to spot) > 100 or (distance to vehicle2) > 100
# This accident report involves a collision at a crossroad between two vehicles, resulting in serious injuries to the drivers. The first vehicle involved was a 2016 Honda Accord sedan driven by a 36-year-old pregnant female. The second vehicle was a 2008 Chrysler Town and Country minivan. The crash occurred during daylight hours on an urban roadway with clear weather conditions and dry road surfaces.\n\nAccording to the investigation, the driver of the Honda Accord experienced a medical event that rendered her unconscious while traveling southbound. As a result, her vehicle veered left through the median and into the northbound lanes where it collided with the front of the Chrysler Town and Country minivan. Both vehicles sustained significant damage from the impact.\n\nThe Honda Accord rotated counterclockwise after the collision and came to rest on a concrete median facing northeast, while the Chrysler minivan was pushed back slightly and ended up in one of the northbound travel lanes facing northeast as well. Emergency responders arrived at the scene promptly to provide medical assistance to both drivers.\n\ndescription: None"