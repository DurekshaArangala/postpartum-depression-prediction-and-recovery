from dotenv import load_dotenv
import os
from src.helper import load_pdf_file, filter_to_minimal_docs, text_split, download_hugging_face_embeddings
from pinecone import Pinecone
from pinecone import ServerlessSpec
from langchain_pinecone import PineconeVectorStore

load_dotenv()

PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
os.environ["PINECONE_API_KEY"] = PINECONE_API_KEY

extracted_data = load_pdf_file(data = 'data/')
filter_data = filter_to_minimal_docs(extracted_data)
text_chunks = text_split(filter_data)

embeddings = download_hugging_face_embeddings()

pinecone_api_key = PINECONE_API_KEY
pc = Pinecone(api_key = pinecone_api_key)

index_name = "medical-chatbot"

vector = embeddings.embed_query("Hello World")

dimension = len(vector)

if not pc.has_index(index_name):
    pc.create_index(
        name=index_name,
        dimension=dimension,
        metric="cosine",
        spec=ServerlessSpec(
            cloud="aws",
            region="us-east-1"
        )
    )

# Connect to the Pinecone index
index = pc.Index(index_name)

# Clean document metadata before uploading to Pinecone
for doc in text_chunks:
    cleaned_metadata = {}

    for key, value in doc.metadata.items():

        if value is None:
            continue

        if isinstance(value, (str, int, float, bool)):
            cleaned_metadata[key] = value

        elif isinstance(value, list) and all(
            isinstance(item, str) for item in value
        ):
            cleaned_metadata[key] = value

    doc.metadata = cleaned_metadata

docsearch = PineconeVectorStore.from_documents(
    documents=text_chunks,
    embedding=embeddings,
    index_name=index_name
)