import React, { useState } from 'react';
import { Button, TextField, Typography } from '@mui/material';

const LUCKY_QUESTIONS = [
  "What is a minimalist entrepreneur?",
  "What is your definition of community?",
  "How do I decide what kind of business I should start?"
];

const QuestionForm = () => {
  const [question, setQuestion] = useState('');
  const [answer, setAnswer] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    try {
      const response = await fetch('/api/ask', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ question }),
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const data = await response.json();
      setAnswer(data.answer);
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return (
    <>
      <form onSubmit={handleSubmit}>
        <TextField
          label="Your question"
          variant="outlined"
          fullWidth
          margin='normal'
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
        />
        <Button type="submit" variant="contained" color="primary" sx={{ marginTop: 2 }}>
          Ask
        </Button>
        <Button
          type="button"
          variant="contained"
          color="secondary"
          sx={{ marginTop: 2, marginLeft: 2 }}
          onClick={() => {
            setQuestion(LUCKY_QUESTIONS[Math.floor(Math.random() * LUCKY_QUESTIONS.length)]);
            handleSubmit({ preventDefault: () => {} });
          }}
        >
          I'm feeling lucky
        </Button>
      </form>
      {answer && (
        <Typography variant="body1" sx={{ marginTop: 2, marginBottom: 8 }}>
          Answer: {answer}
        </Typography>
      )}
    </>
  );
};

export default QuestionForm;
