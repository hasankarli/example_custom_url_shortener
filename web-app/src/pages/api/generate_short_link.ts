import { ref, set } from 'firebase/database';
import database from '../../firebase/database';
import CryptoJS from 'crypto-js';

export const prerender = false;


const db = database;


export const POST = async ({ request }) => {
  console.log("Request received");

  try {
    const body = await request.json();

    let originalLink = body.originalLink;
    let androidPackageName = body.androidPackageName;
    let iosBundleId = body.iosBundleId;
    let title = body.title;
    let description = body.description;
    let imageUrl = body.imageUrl;

    const randomBytes = CryptoJS.lib.WordArray.random(4);
    const shortId = randomBytes.toString(CryptoJS.enc.Hex);

    const shortLink = `https://examplecustomurlshortener-hasankarlis-projects.vercel.app/link/${shortId}`;
    

    await set(ref (db, 'short-links/' + shortId), {
      originalLink,
      androidPackageName,
      iosBundleId,
      title,
      description,
      imageUrl,
      shortLink
    });

     

    return new Response(
      JSON.stringify({
        shortLink
      }),
      {
        status: 200,
      }
      
    )
  } catch (error) {
    console.error(error);
    return {
      status: 500,
      body: {
        message: "Error generating short link"
      }
    };
  }
}