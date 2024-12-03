#  仅使用few-shots,未使用RAG的输出效果

使用的prompt为：

```python
system_content="""You are an expert in writing traffic accident reports.

Your current task is to compose a traffic accident report that meets the specific requirements provided by the user.

The user's input is primarily related to the specific type of traffic accident"""

prompt='The crash configuration is about angle/sideswipe'
```

## 以下是生成全文

This crash involves a 2019 Toyota Camry four-door sedan and a 2017 Honda Accord four-door sedan that were primarily involved in an angle/sideswipe collision. The crash occurred during daylight hours on a straight, level, four-lane divided highway with a speed limit of 96 km/h (60 mph). The weather conditions were clear, and the roadway surfaces were dry.

Vehicle 1, the 2019 Toyota Camry sedan, was being driven by a 45-year-old male driver in the right lane of the northbound travel direction. The driver of Vehicle 1 intended to continue traveling north.

Vehicle 2, the 2017 Honda Accord sedan, was being driven by a 35-year-old female driver in the left lane of the northbound travel direction. The driver of Vehicle 2 intended to change lanes to the right lane.

As Vehicle 2 attempted to change lanes into the right lane where Vehicle 1 was traveling, the right side of Vehicle 2 made contact with the left side of Vehicle 1 (event 1). The impact caused Vehicle 1 to veer slightly to the right before the driver was able to regain control and bring the vehicle to a stop on the right shoulder facing north. Vehicle 2 continued traveling north before coming to a controlled stop on the left shoulder facing north. Both vehicles sustained minor damage to their left and right sides.

The driver of Vehicle 1 was the sole occupant and was properly restrained by the three-point lap and shoulder belt. The vehicle was equipped with advanced frontal airbags, seat-mounted side airbags, and side curtain airbags, none of which deployed during the crash. The driver of Vehicle 1 reported no injuries at the scene.

The driver of Vehicle 2 was also the sole occupant and was properly restrained by the three-point lap and shoulder belt. Vehicle 2 was equipped with advanced frontal airbags, seat-mounted side airbags, and side curtain airbags, none of which deployed during the crash. The driver of Vehicle 2 reported no injuries at the scene.

Both drivers exchanged insurance information and were able to drive their vehicles from the scene. No further medical attention was required.