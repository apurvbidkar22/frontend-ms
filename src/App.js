import React, { useEffect, useState } from "react";

function App() {
  const [data, setData] = useState([]);

  useEffect(() => {
    fetch(process.env.REACT_APP_BACKEND_URL + "/data")
      .then(res => res.json())
      .then(setData);
  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <h1>OpenShift Demo App</h1>
      <h3>Messages from Backend:</h3>
      <ul>
        {data.map(d => (
          <li key={d.id}>{d.msg}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
