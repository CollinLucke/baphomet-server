import express from 'express';
import cors from 'cors';
import movies from '../server/routes/movie.js';
import gql from 'graphql-tag';
import { ApolloServer } from '@apollo/server';
import { buildSubgraphSchema } from '@apollo/subgraph';
import { expressMiddleware } from '@apollo/server/express4';
import resolvers from '../src/resolvers.js';
import { readFileSync } from 'fs';
import { ApolloServerPluginLandingPageDisabled } from '@apollo/server/plugin/disabled'

const PORT = 5050;
const app = express();

app.use(cors());
app.use(express.json());

const typeDefs = gql(
  readFileSync('./src/schema.graphql', {
    encoding: 'utf-8'
  })
);

const server = new ApolloServer({
  schema: buildSubgraphSchema({ typeDefs, resolvers }),
  introspection: process.env.NODE_ENV !== 'production',
  plugins: [process.env.NODE_ENV === 'production' ? ApolloServerPluginLandingPageDisabled() : null]
});

await server.start();

app.use('/movies', movies);

app.use('/graphql', cors(), express.json(), expressMiddleware(server));

app.listen(PORT, () => {
  console.log(`🚀 Server listening on port ${PORT}`);
});
