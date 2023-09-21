import { FC } from 'react'

export type LittleHeadingProps = {
  children: any
}

export const LittleHeading: FC<LittleHeadingProps> = ({ children }) => {
  return (
    <h2 className="font-heading scroll-m-20 text-xl font-semibold tracking-tight pl-4 border-t border-b border-slate-200 p-4">
      {children}
    </h2>
  )
}
