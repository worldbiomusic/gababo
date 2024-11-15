import { useState, useEffect } from 'react'
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Coins } from "lucide-react"
import Image from "next/image"
import { ConnectButton } from '@rainbow-me/rainbowkit'

export function GameInterface() {
  const [timeLeft, setTimeLeft] = useState(8)
  const [progress, setProgress] = useState(100)
  const [selectedMove, setSelectedMove] = useState<string | null>(null)
  const [formData, setFormData] = useState({
    address: '0x..',
    message: "I'm rock, really",
    tokenToLock: '0.01',
    endsIn: '0.01'
  })

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 0) return 0
        const newProgress = ((prev - 1) * 100) / 8
        setProgress(newProgress)
        return prev - 1
      })
    }, 1000)
    return () => clearInterval(timer)
  }, [])

  return (
    <div className="min-h-screen bg-teal-800">
      {/* Header */}
      <div className="container mx-auto p-4">
        <div className="flex justify-between items-center mb-8">
          <div className="w-32" /> {/* Spacer */}
          <div className="bg-teal-900 rounded-full p-4 text-white text-xl">
            <Image
              src="/imgs/rps.png"
              alt="Player RED"
              width={40}
              height={40}
              className="w-full h-full object-contain"
            />
          </div>
          <ConnectButton />

          {/* 기존 Connect Button */}
          {/* <div className="bg-teal-900 rounded-xl px-6 py-3"> */}
          {/* <span className="text-white text-xl">Wallet connected</span> */}
          {/* </div> */}
        </div>

        {/* Game Area */}
        <div className="bg-teal-900/50 rounded-3xl p-8 backdrop-blur-sm">
          <div className="grid grid-cols-3 gap-8 items-center">
            {/* Left Player */}
            <div className="bg-blue-600 rounded-2xl p-6 text-center">
              <div className="bg-blue-500/50 text-white py-2 px-4 rounded-xl mb-4 inline-block">
                {'waiting blue player...'}
              </div>
              <div className="bg-blue-700 rounded-full p-6 w-32 h-32 mx-auto mb-4">
                <Image
                  src="/imgs/question_mark.png"
                  alt="Player BLUE"
                  width={80}
                  height={80}
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="text-white mb-2"><a href="https://etherscan.io/">0x...</a></div>
              <div className="bg-blue-500/50 text-white py-2 px-4 rounded-xl">
                0.05 ether <b>locked</b>
              </div>
            </div>

            {/* Center - Prize and Timer */}
            <div className="flex flex-col items-center justify-center gap-4">
              <h2 className="text-3xl font-bold text-white mb-2">Dashboard</h2>
              <div className="bg-teal-700 text-white py-3 px-8 rounded-full flex items-center gap-2">
                <Coins className="w-6 h-6" />
                <span className="text-xl">0.1 ether</span>
              </div>

              <div className="relative w-48">
                <Progress value={progress} className="h-2" />
                <div className="absolute top-4 left-0 right-0 text-center text-white">
                  <div className="text-3xl font-bold">{timeLeft}</div>
                  <div className="text-sm">seconds</div>
                </div>
              </div>
            </div>

            {/* Right Player */}
            <div className="bg-red-600 rounded-2xl p-6 text-center">
              <div className="bg-red-500/50 text-white py-2 px-4 rounded-xl mb-4 inline-block">
                {'waiting red player...'}
              </div>
              <div className="bg-red-700 rounded-full p-6 w-32 h-32 mx-auto mb-4">
                <Image
                  src="/imgs/question_mark.png"
                  alt="Player RED"
                  width={80}
                  height={80}
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="text-white mb-2">0x...</div>
              <div className="bg-red-500/50 text-white py-2 px-4 rounded-xl">
                0.05 ether <b>locked</b>
              </div>
            </div>
          </div>
        </div>

        {/* Enter Game Button */}
        <div className="flex justify-center mt-8">
          <Dialog>
            <DialogTrigger asChild>
              <Button className="bg-teal-900 text-white hover:bg-teal-800 px-12 py-6 text-2xl rounded-2xl">
                Enter Game
              </Button>
            </DialogTrigger>
            <DialogContent className="bg-teal-900 text-white border-0 sm:max-w-[425px]">
              <DialogHeader>
                <DialogTitle className="text-2xl text-center">Join game</DialogTitle>
              </DialogHeader>
              <div className="grid gap-4 py-4">
                <div className="grid gap-2">
                  <Label className="text-white">address</Label>
                  <Input
                    value={formData.address}
                    onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                    className="bg-teal-800 border-0 text-white"
                  />
                </div>
                <div className="grid gap-2">
                  <Label className="text-white">message</Label>
                  <Input
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    className="bg-teal-800 border-0 text-white"
                  />
                </div>
                <div className="grid gap-2">
                  <Label className="text-white">Token to lock</Label>
                  <div className="flex gap-2">
                    <Input
                      value={formData.tokenToLock}
                      onChange={(e) => setFormData({ ...formData, tokenToLock: e.target.value })}
                      className="bg-teal-800 border-0 text-white"
                    />
                    <div className="bg-teal-800 px-4 py-2 rounded-md">ETH</div>
                  </div>
                </div>
                <div className="grid gap-2">
                  <Label className="text-white">Ends in</Label>
                  <div className="flex gap-2">
                    <Input
                      value={formData.endsIn}
                      onChange={(e) => setFormData({ ...formData, endsIn: e.target.value })}
                      className="bg-teal-800 border-0 text-white"
                    />
                    <div className="bg-teal-800 px-4 py-2 rounded-md">sec</div>
                  </div>
                </div>
                <div className="flex justify-center gap-4 my-4">
                  {['rock', 'paper', 'scissors'].map((move) => (
                    <Button
                      key={move}
                      onClick={() => setSelectedMove(move)}
                      className={`bg-teal-800 rounded-full p-6 w-24 h-24 ${selectedMove === move ? 'ring-2 ring-white' : ''
                        }`}
                    >
                      <Image
                        src={`/imgs/${move}.png`}
                        alt={move}
                        width={40}
                        height={40}
                        className="w-full h-full object-contain"
                      />
                    </Button>
                  ))}
                </div>
                <Button className="w-full bg-teal-800 hover:bg-teal-700">
                  Confirm
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>
    </div>
  )
}