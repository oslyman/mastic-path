import React from "react";
import QuestionForm from './QuestionForm';
import { CssBaseline, Grid, Link, ThemeProvider, Typography } from '@mui/material';
import theme from './theme';

function Homepage() {
  return (
    <>
      <CssBaseline />
      <ThemeProvider theme={theme}>
        <Grid container justifyContent="center" alignItems="center" style={{ padding: 16, height: '100vh' }}>
          <Grid item xs={12} sm={8} md={6}>
            <Link
              href={"https://www.amazon.com/Minimalist-Entrepreneur-Great-Founders-More/dp/0593192397"}
              target="_blank"
              rel="noopener noreferrer"
            >
              {/** This image source should ideally be self-hosted */}
              <img
                src={"https://askmybook.com/static/book.2a513df7cb86.png"}
                alt={"The Minimalist Entrepreneur by Sahil Lavingia"}
                style={{ width: '50%' }}
              />
            </Link>
            <Typography variant="h4" gutterBottom>
              Ask my book
            </Typography>
            <Typography variant="body1">
              This is an experiment in using AI to make my book's content more accessible. Ask a question and AI'll answer it in real-time:
            </Typography>
            <QuestionForm />
          </Grid>
        </Grid>
      </ThemeProvider>
    </>
  );
}

export default Homepage;