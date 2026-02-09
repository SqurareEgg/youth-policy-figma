import type { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  const now = new Date();
  
  // 서버 로그 출력
  console.log("--- [TS API] Server Time ---");
  console.log(`UTC: ${now.toISOString()}`);
  
  const kstTime = new Date(now.getTime() + (9 * 60 * 60 * 1000));
  console.log(`KST: ${kstTime.toISOString()}`);

  res.status(200).json({
    utc: now.toISOString(),
    kst: kstTime.toISOString()
  });
}
