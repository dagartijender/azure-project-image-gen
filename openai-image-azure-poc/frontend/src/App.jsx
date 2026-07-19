import { useState } from "react";

// In Azure AKS, requests flow:
// React -> Azure Front Door -> Application Gateway -> kgateway -> Istio -> FastAPI
const API_BASE = import.meta.env.VITE_API_BASE_URL || "/api";

export default function App() {
  const [email, setEmail] = useState("");
  const [prompt, setPrompt] = useState("");
  const [size, setSize] = useState("1024x1024");
  const [quality, setQuality] = useState("medium");

  const [job, setJob] = useState(null);
  const [gallery, setGallery] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  async function createJob(event) {
    event.preventDefault();

    setLoading(true);
    setMessage("Submitting Azure AI Image Generation Job...");
    setJob(null);

    try {
      const response = await fetch(`${API_BASE}/generate`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          prompt,
          size,
          quality,
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.detail || "Request failed");
      }

      const data = await response.json();

      setJob(data);

      setMessage(`Job Submitted Successfully

Job ID: ${data.job_id}

Status: ${data.status}`);

      pollJob(data.job_id);
    } catch (error) {
      setMessage(error.message);
    } finally {
      setLoading(false);
    }
  }

  async function pollJob(jobId) {
    let completed = false;

    while (!completed) {
      await new Promise((resolve) => setTimeout(resolve, 5000));

      const response = await fetch(`${API_BASE}/jobs/${jobId}`);
      const data = await response.json();

      setJob(data);

      setMessage(`Current Status : ${data.status}`);

      if (
        data.status === "COMPLETED" ||
        data.status === "FAILED"
      ) {
        completed = true;
      }
    }
  }

  async function loadGallery() {
    if (!email) {
      setMessage("Please enter your email.");
      return;
    }

    setMessage("Loading Azure Blob Storage images...");

    const response = await fetch(
      `${API_BASE}/users/${encodeURIComponent(email)}/images`
    );

    const data = await response.json();

    setGallery(data);

    setMessage(`${data.length} image(s) loaded.`);
  }

  return (
    <main className="page">

      {/* ===========================
           Hero Section
      ============================ */}

      <section className="hero">

        <div>

          <p className="eyebrow">
            Azure Front Door • Application Gateway • kgateway • Istio • AKS • Azure OpenAI
          </p>

          <h1>Enterprise Azure AI Image Generator</h1>

          <p className="subtext">
            Generate AI-powered images using Azure OpenAI.
            Requests are processed asynchronously through Azure Service Bus,
            executed by Kubernetes workers,
            stored securely in Azure Blob Storage,
            and tracked in Azure PostgreSQL.
          </p>

        </div>

      </section>

      {/* ===========================
          Architecture
      ============================ */}

      <section className="card">

        <h2>Architecture Flow</h2>

        <pre style={{ whiteSpace: "pre-wrap" }}>
{`
User
   │
   ▼
Azure Front Door
   │
   ▼
Application Gateway
   │
   ▼
kgateway (Gateway API)
   │
   ▼
Istio Service Mesh
   │
   ▼
FastAPI Backend
   │
   ▼
Azure Service Bus
   │
   ▼
Worker Deployment
   │
   ▼
Azure OpenAI
   │
   ▼
Azure Blob Storage
   │
   ▼
Azure PostgreSQL
`}
        </pre>

      </section>

      {/* ===========================
          Form
      ============================ */}

      <section className="card">

        <form onSubmit={createJob}>

          <label>Email</label>

          <input
            type="email"
            value={email}
            placeholder="user@example.com"
            required
            onChange={(e) => setEmail(e.target.value)}
          />

          <label>Prompt</label>

          <textarea
            value={prompt}
            required
            placeholder="Generate an Azure architecture diagram using Azure OpenAI, AKS, Istio, kgateway, Azure Service Bus, Azure Blob Storage and Azure PostgreSQL..."
            onChange={(e) => setPrompt(e.target.value)}
          />

          <div className="grid">

            <div>

              <label>Image Size</label>

              <select
                value={size}
                onChange={(e) => setSize(e.target.value)}
              >
                <option value="1024x1024">1024 x 1024</option>
                <option value="1536x1024">1536 x 1024</option>
                <option value="1024x1536">1024 x 1536</option>
                <option value="2048x1152">2048 x 1152</option>
              </select>

            </div>

            <div>

              <label>Quality</label>

              <select
                value={quality}
                onChange={(e) => setQuality(e.target.value)}
              >
                <option value="low">Low</option>
                <option value="medium">Medium</option>
                <option value="high">High</option>
                <option value="auto">Auto</option>
              </select>

            </div>

          </div>

          <button disabled={loading}>
            {loading
              ? "Submitting..."
              : "Generate Image"}
          </button>

          <button
            type="button"
            className="secondary"
            onClick={loadGallery}
          >
            Load My Images
          </button>

        </form>

      </section>

      {/* ===========================
           Status
      ============================ */}

      {message && (
        <p className="message">
          {message}
        </p>
      )}

      {/* ===========================
          Current Job
      ============================ */}

      {job && (

        <section className="card result">

          <h2>Current Job</h2>

          <p>
            <strong>Job ID:</strong> {job.job_id}
          </p>

          <p>
            <strong>Status:</strong> {job.status}
          </p>

          {job.error && (
            <p className="error">
              <strong>Error:</strong> {job.error}
            </p>
          )}

          {job.image_url && (
            <img
              src={job.image_url}
              alt="Generated AI Image"
            />
          )}

        </section>

      )}

      {/* ===========================
          Gallery
      ============================ */}

      {gallery.length > 0 && (

        <section className="gallery">

          <h2>Generated Images</h2>

          <div className="galleryGrid">

            {gallery.map((item) => (

              <article
                className="galleryItem"
                key={item.job_id}
              >

                {item.image_url ? (

                  <img
                    src={item.image_url}
                    alt={item.prompt}
                  />

                ) : (

                  <div className="placeholder">
                    {item.status}
                  </div>

                )}

                <p>{item.prompt}</p>

                <small>{item.status}</small>

              </article>

            ))}

          </div>

        </section>

      )}

    </main>
  );
}
