export type ReportNavItem = {
  name: string
  path: string
  active: boolean
}

export type ReportNavProps = {
  items: ReportNavItem[]
}

export function ReportNav(props: ReportNavProps) {
  return (
    <>
      <div className="flex flex-row">
        <div className="flex h-screen flex-col justify-between border-e bg-white">
          <div className="px-4 py-6">
            <ul className="mt-6 space-y-1">
              {props.items.map((i) => (
                <li key={i.path}>
                  <a
                    href={i.path}
                    className={
                      i.active
                        ? 'block rounded-lg bg-gray-100 px-4 py-2 text-sm font-medium text-gray-700'
                        : 'block rounded-lg px-4 py-2 text-sm font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-700'
                    }
                  >
                    {i.name}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </>
  )
}
