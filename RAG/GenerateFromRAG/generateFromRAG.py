from langchain.document_loaders import CSVLoader
local_doc_path = 'accidentLabeled.csv'
loader = CSVLoader(file_path=local_doc_path,encoding='utf-8')
docs = loader.load()

from langchain_community.embeddings import HuggingFaceEmbeddings
model_name = "sentence-transformers/all-MiniLM-L6-v2"
embeddings = HuggingFaceEmbeddings(model_name=model_name)
import random


from langchain.vectorstores import DocArrayInMemorySearch
from langchain.llms import OpenAI
db = DocArrayInMemorySearch.from_documents(docs, embeddings)



from gen import generate
import json

json_file = 'output.json'
data=[]
for i in range(100):
    print(i)
    query = random.choice(['crossroad collision', 'face to face collision', 'multiple cars collision', 'single car accident', 'rear end'])
    embed = embeddings.embed_query(query)
    relative_docs = db.similarity_search(query)
    context = "".join([doc.page_content for doc in relative_docs])
    prompt=f"""You are an expert in generating accident reports. Please generate accident report about {query}, and here are some examples of relative accident reports: {context}"""
    #prompt=f"""You are an expert in generating accident reports. Please generate accident report about {query}."""
    response = generate(prompt=prompt)
    new_data = {'query': query, 'response': response}
    data.append(new_data)
    with open(json_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)