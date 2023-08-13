import { useEffect, useState } from 'react';
import * as cocoSsd from '@tensorflow-models/coco-ssd';
import '@tensorflow/tfjs';

const ObjectDetector = () => {
  const [model, setModel] = useState(null);
  const [predictions, setPredictions] = useState([]);
  const [isMobile, setIsMobile] = useState(false);

  // Load the model when component mounts
  useEffect(() => {
    async function loadModel() {
      const loadedModel = await cocoSsd.load();
      setModel(loadedModel);
    }

    loadModel();

    // Check if mobile
    setIsMobile(window.innerWidth <= 768);
  }, []);

  useEffect(() => {
    let animationId: number;

    async function detectObjects(videoElement: HTMLVideoElement) {
      if (model) {
        const newPredictions = await model.detect(videoElement);
        setPredictions(newPredictions);

        animationId = requestAnimationFrame(() => {
          detectObjects(videoElement);
        });
      }
    }

    const videoElement = document.getElementById('videoFeed') as HTMLVideoElement;
    if (videoElement) {
      detectObjects(videoElement);
    }

    return () => {
      cancelAnimationFrame(animationId);
    };
  }, [model]);

  // Access the mobile camera and play the feed
  useEffect(() => {
    if (isMobile) {
      const videoElement = document.getElementById('videoFeed') as HTMLVideoElement;

      if (videoElement) {
        navigator.mediaDevices.getUserMedia({ video: true })
          .then((stream) => {
            videoElement.srcObject = stream;
            videoElement.play();
          });
      }
    }
  }, [isMobile]);

  return (
    <div>
      {isMobile && <video id="videoFeed" width="300" height="300" />}
      <div>
        <p>Detected Objects: {predictions.length}</p>
        {predictions.map((prediction, index) => (
          <div key={index}>
            <p>{prediction.class}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ObjectDetector;