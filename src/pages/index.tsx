import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import { GameInterface } from './../components/game-interface';

const Home: NextPage = () => {
  return (
    // <div className={styles.container}>
    <div>
      <Head>
        <title>RainbowKit App</title>
        <meta
          content="Generated by @rainbow-me/create-rainbowkit"
          name="description"
        />
        <link href="/favicon.ico" rel="icon" />
      </Head>

      <GameInterface/>
      
      {/* <main className={styles.main}>
        <ConnectButton />
        
        
      </main>

      <footer className={styles.footer}>
        <b>Gababo ✌️✊🖐️</b>
      </footer> */}
    </div>
  );
};

export default Home;
