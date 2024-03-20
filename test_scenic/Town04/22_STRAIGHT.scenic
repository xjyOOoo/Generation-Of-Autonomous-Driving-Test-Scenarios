param map = localPath('../maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
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

ego_maneuvers = filter(lambda i: i.type == ManeuverType.STRAIGHT, ego_startLane.maneuvers)
ego_maneuver = Uniform(*ego_maneuvers)
# ego_trajectory = [ego_maneuver.startLane, ego_maneuver.connectingLane, ego_maneuver.endLane]

adv_maneuvers = filter(lambda i: i.type == ManeuverType.LEFT_TURN, ego_maneuver.conflictingManeuvers)
adv_maneuver = Uniform(*adv_maneuvers)
adv_trajectory = [adv_maneuver.startLane, adv_maneuver.connectingLane, adv_maneuver.endLane]

ego_spawn_pt = OrientedPoint in ego_maneuver.startLane.centerline
adv_spawn_pt = OrientedPoint in adv_maneuver.startLane.centerline

ego = Car at ego_spawn_pt,
    with blueprint "vehicle.toyota.prius",
    with rolename "hero"

adversary = Car at adv_spawn_pt,
    with blueprint "vehicle.bmw.grandtourer",
    with behavior AdversaryBehavior(adv_trajectory)

require 15 <= (distance to intersec) <= 20
require 10 <= (distance from adversary to intersec) <= 15
terminate when (distance to ego_spawn_pt) > 70# "This angle/sideswipe crash case involves a 2012 Toyota Camry sedan and a 2015 Honda Accord sedan. The case occupant is the restrained driver of the Toyota Camry, who sustained injuries due to the angle/sideswipe collision.\n\nThe crash occurred during daylight hours at a T-intersection where the northbound two-lane asphalt road meets the eastbound two-lane asphalt road. The weather was clear, and the road surfaces were dry. The speed limit on both roads was 56 km/h (35 mph).\n\nVehicle 1, the 2012 Toyota Camry sedan, was traveling north on the two-lane road approaching the T-intersection. The driver of Vehicle 1 intended to continue straight through the intersection.\n\nVehicle 2, the 2015 Honda Accord sedan, was traveling east on the intersecting road approaching the same intersection. The driver of Vehicle 2 intended to make a left turn to head north.\n\nAs Vehicle 1 entered the intersection, it was struck on the left side by the front of Vehicle 2 in an angle/sideswipe manner. The impact caused Vehicle 1 to rotate counterclockwise until it came to rest on the east side of the intersection, facing northwest. Vehicle 2 continued eastbound after the collision and came to a stop on the eastbound lane, facing east.\n\nThe driver of Vehicle 1, a 35-year-old male, was restrained by the three-point lap and shoulder belt. The driver's frontal airbag deployed upon impact. The driver sustained injuries and was transported to a local hospital for treatment. The driver of Vehicle 2, a 40-year-old female, sustained minor injuries and was treated at the scene.\n\nBoth vehicles were towed from the scene due to damage sustained in the crash. The driver of Vehicle 1 was enrolled as the case occupant in this angle/sideswipe collision."