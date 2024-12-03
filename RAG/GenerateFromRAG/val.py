from sentence_transformers import SentenceTransformer
def calculate_similarity(model, x, y):
    sentences_1 = [x]
    sentences_2 = [y]
    embeddings_1 = model.encode(sentences_1, normalize_embeddings=True)
    embeddings_2 = model.encode(sentences_2, normalize_embeddings=True)
    similarity = embeddings_1 @ embeddings_2.T
    print(similarity)
    return similarity[0][0]



model = SentenceTransformer('BAAI/bge-large-en-v1.5')
import json
import random
data=json.load(open(f"accident_7B_RAG_ft.json"))
test_data = []
import csv
with open('accidentLabeled.csv', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        test_data.append(row)

output=[]
for i in range(len(data)):
    choice = []
    for item in test_data:
        if item['type'] == data[i]['query']:
            choice.append(item['description'])
    score = calculate_similarity(model, data[i]['response'], random.choice(choice))
    output.append({'type':data[i]['query'],'score':str(score)})
    with open('res_7B_ft.json', 'w') as f:
        json.dump(output, f, indent=4)    



import json
data=json.load(open(f"res_7B_ft.json"))
score={'crossroad collision':0, 'face to face collision':0, 'multiple cars collision':0, 'single car accident':0, 'rear end':0}
count={'crossroad collision':0, 'face to face collision':0, 'multiple cars collision':0, 'single car accident':0, 'rear end':0}
for i in range(len(data)):
    score[data[i]['type']]+=float(data[i]['score'])
    count[data[i]['type']]+=1
for key in score.keys():
    score[key]/=count[key]
with open("score7B_ft.json",'w') as f:
    json.dump(score, f, indent=4)

