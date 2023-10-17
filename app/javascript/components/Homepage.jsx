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
            <Typography variant="h4" gutterBottom>
              Consigliere
            </Typography>
            <Typography variant="body1">
              This is an experiment in using AI to answer questions about political stragegy. It will use the wisdom of Niccolo Machievelli's "The Prince" to answer your questions:
            </Typography>
            <QuestionForm />
          </Grid>
        </Grid>
      </ThemeProvider>
    </>
  );
}

export default Homepage;