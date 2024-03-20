param map = localPath('../maps/CARLA/Town07.xodr')
param carla_map = 'Town07'
param render = '0'
model scenic.simulators.carla.model

EGO_SPEED = 10
SAFETY_DISTANCE = 20
BRAKE_INTENSITY = 1.0

monitor StopAfterTimeInIntersection:
    totalTime = 0
    while totalTime < 1000:
        totalTime += 1
        wait
    terminate

monitor TrafficLights:
    freezeTrafficLights()
    while True:
        if withinDistanceToTrafficLight(ego, 100):
            setClosestTrafficLightStatus(ego, "green")
        if withinDistanceToTrafficLight(adversary, 100):
            setClosestTrafficLightStatus(adversary, "red")
        wait

behavior AdversaryBehavior(trajectory):
    while (ego.speed < 1):
        wait
    do FollowTrajectoryBehavior(trajectory=trajectory)

fourWayIntersection = filter(lambda i: i.is4Way and i.isSignalized, network.intersections)

intersec = Uniform(*fourWayIntersection)
ego_startLane = Uniform(*intersec.incomingLanes)

ego_maneuvers = filter(lambda i: i.type == ManeuverType.LEFT_TURN, ego_startLane.maneuvers)
ego_maneuver = Uniform(*ego_maneuvers)
# ego_trajectory = [ego_maneuver.startLane, ego_maneuver.connectingLane, ego_maneuver.endLane]

adv_maneuvers = filter(lambda i: i.type == ManeuverType.STRAIGHT, ego_maneuver.conflictingManeuvers)
adv_maneuver = Uniform(*adv_maneuvers)
adv_trajectory = [adv_maneuver.startLane, adv_maneuver.connectingLane, adv_maneuver.endLane]

ego_spawn_pt = OrientedPoint in ego_maneuver.startLane.centerline
adv_spawn_pt = OrientedPoint in adv_maneuver.startLane.centerline

ego = Car at ego_spawn_pt,
    with blueprint "vehicle.lincoln2020.mkz2020",
    with rolename "hero"

adversary = Car at adv_spawn_pt,
    with blueprint "vehicle.mini.cooperst",
    with behavior AdversaryBehavior(adv_trajectory)

require 15 <= (distance to intersec) <= 20
require 10 <= (distance from adversary to intersec) <= 15
terminate when (distance to ego_spawn_pt) > 70# "This angle/sideswipe crash case involves a 2012 Toyota Camry sedan and a 2015 Honda Accord sedan. The case occupant is the restrained driver of the Toyota Camry, who sustained injuries due to the angle/sideswipe collision.\n\nThe crash occurred during daylight hours at a T-intersection where a two-lane asphalt road meets a four-lane divided highway. The weather was clear, and the road surfaces were dry. The speed limit on the divided highway is 64 km/h (40 mph).\n\nVehicle 1, the 2012 Toyota Camry sedan, was traveling east on the two-lane road approaching the T-intersection. The driver of Vehicle 1 intended to make a left turn onto the divided highway.\n\nVehicle 2, the 2015 Honda Accord sedan, was traveling south on the divided highway in the right lane approaching the T-intersection.\n\nAs Vehicle 1 was making a left turn onto the divided highway, it entered the path of Vehicle 2. The front of Vehicle 2 impacted the left side of Vehicle 1 in an angle/sideswipe manner. The impact caused Vehicle 1 to rotate clockwise, coming to rest on the east side of the intersection, facing northeast. Vehicle 2 yawed counterclockwise, crossed into the inside southbound lane, and came to rest in the southbound left-turn lane facing northeast.\n\nThe driver of Vehicle 1, a 35-year-old male, was restrained by a three-point lap and shoulder belt. The driver had the benefit of a deployed frontal airbag. The driver sustained injuries and was transported to a local hospital for treatment. The driver of Vehicle 2, a 40-year-old female, sustained visible injuries, but her treatment status is unknown.\n\nBoth vehicles were towed from the scene due to damage sustained in the crash. The driver of Vehicle 1 was enrolled as the case occupant in this angle/sideswipe crash report."