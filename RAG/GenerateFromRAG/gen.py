from transformers import AutoModelForCausalLM, AutoTokenizer
import time
import json
import re
from openai import OpenAI
# Set OpenAI's API key and API base to use vLLM's API server.
openai_api_key = "EMPTY"
openai_api_base = "http://localhost:8000/v1"

import time
print(time.time())

client = OpenAI(
    api_key=openai_api_key,
    base_url=openai_api_base,
)


def generate(prompt):
    chat_response = client.chat.completions.create(
        model="Qwen/Qwen2.5-7B-Instruct",
        messages=[
            {"role": "system", "content": "You are Qwen, created by Alibaba Cloud. You are a helpful assistant."},
            {"role": "user", "content": prompt},
        ],
        temperature=1,
        top_p=0.9,
        max_tokens=2048,
        extra_body={
            "repetition_penalty": 1,
        },
    )
    return chat_response.choices[0].message.content


prompt="""
below is a Scenic script, your task is to generate another scenic scirpt that is different from the original one but still valid.
param map = localPath('../maps/CARLA/Town01.xodr')
param carla_map = 'Town01'
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

adv_maneuvers = filter(lambda i: i.type == ManeuverType.RIGHT_TURN, ego_maneuver.conflictingManeuvers)
adv_maneuver = Uniform(*adv_maneuvers)
adv_trajectory = [adv_maneuver.startLane, adv_maneuver.connectingLane, adv_maneuver.endLane]

ego_spawn_pt = OrientedPoint in ego_maneuver.startLane.centerline
adv_spawn_pt = OrientedPoint in adv_maneuver.startLane.centerline

ego = Car at ego_spawn_pt,
    with blueprint "vehicle.tesla.model3",
    with rolename "hero"

adversary = Car at adv_spawn_pt,
    with blueprint "vehicle.mini.cooperst",
    with behavior AdversaryBehavior(adv_trajectory)

require 15 <= (distance to intersec) <= 20
require 10 <= (distance from adversary to intersec) <= 15"""
